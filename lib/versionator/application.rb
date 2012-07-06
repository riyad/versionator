
require 'haml'
require 'json'
require 'sass'
require 'sinatra/base'
require 'sinatra/reloader'

require 'versionator/detector'

module Versionator
  class Application < Sinatra::Base

    configure do
      # set root to the actual project root
      set :root, File.dirname(__FILE__) + '/../..'

      # the name of the file containing the directories to be checked
      set :check_dirs, 'check_dirs'
    end

    configure(:development) do
      register Sinatra::Reloader
      also_reload "*.rb"
      also_reload "lib/**/*.rb"
    end



    helpers do
      # Inserts a throbber image which will be hidden by default.
      # The image will have the +busy+ class.
      def busy_indicator
        %Q{<img src="images/busy.gif" class="busy" />}
      end

      def app_for_dir(dir)
        @app_for_dir ||= {}
        return @app_for_dir[dir] if @app_for_dir[dir]

        detectors.each do |det|
          app = det.new(dir)
          if app.detected?
            @app_for_dir[dir] = app
            return app
          end
        end

        nil # in case nothing was found
      end

      # Returns an array of all known detectors.
      # This list will be sorted.
      #
      # See also: +Detector#all+
      def detectors
        @detectors ||= Versionator::Detector.all.sort_by(&:basic_name)
      end

      # Returns a list of directories found in the file set in the _check_dirs_ setting.
      def directories
        return @expanded_dirs if @expanded_dirs

        raw_dirs = File.readlines(settings.check_dirs).map(&:chomp)
        simple_dirs = raw_dirs.reject{ |line| line.empty? || line.start_with?('#') }
        expanded_dirs = simple_dirs.map do |line|
          expanded = Dir.glob(line)
          if expanded.empty?
            # return original line for error reporting
            line
          else
            # only return directories
            expanded.select{ |dir| File.directory?(dir) }
          end
        end
        @expanded_dirs = expanded_dirs.flatten.sort_by(&:downcase)
      end

      # Turns a directory into a string suited to be used as a HTML element's id.
      def dom_id_for_dir(dir)
        dir.gsub(/(\/|\.)/, '-')
      end

      # Inserts the image named _name_.
      # You can add html options using the _html_options_ hash.
      def image(name, html_options = {})
        %Q{<img src="images/#{name}.png" alt="#{name}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]} #{%Q{style="#{html_options[:style]}"} if html_options[:style]}/>}
      end

      # Instert a link to _href_ showing the given _text_.
      # You can add html options using the _html_options_ hash.
      def link_to(text, href, html_options = {})
        %Q{<a href="#{href}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]}>} +
          text +
        %Q{</a> }
      end

      def link_to_app_project(app)
        link_to_external("#{app.app_name} Website", app.project_url)
      end

      def link_to_external(text, href, html_options = {})
        %Q{<a href="#{href}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]}>} +
          text +
          %Q{ <i class="icon-share link-external"></i>} +
        %Q{</a> }
      end

      # Inserts the (big) logo for the given _detector_.
      def logo_for(detector)
        logo(detector.basic_name)
      end

      def logo(basic_name)
        %Q{<img src="images/logos/#{basic_name}.png" alt="#{basic_name}" />}
      end

      # Inserts the mini logo for the given _detector_.
      def mini_logo_for(detector)
        logo("#{detector.basic_name}-mini")
      end
    end



    get '/' do
      dirs = directories
      dirs_that_dont_exist = dirs.reject { |dir| Dir.exists?(dir) }
      dirs_that_exist = dirs - dirs_that_dont_exist

      app_for_dir = {}
      dirs_that_exist.each do |dir|
        app_for_dir[dir] = app_for_dir(dir)
      end

      @app_for_dir = app_for_dir
      @detectors = detectors
      @dirs_that_dont_exist = dirs_that_dont_exist
      @dirs_that_exist = dirs_that_exist

      haml :index, :layout => !request.xhr?
    end

    get '/about' do
      haml :about
    end

    # FIXME: remove
    get '/applications' do
      all_apps = detectors
      installs_for_app = Hash.new([])
      directories.each do |dir|
        app = app_for_dir(dir)
        installs_for_app[app.class] += [app] if app
      end

      # only show apps that have actual installs
      @apps = installs_for_app.keys.sort_by(&:basic_name)
      @installs_for_app = installs_for_app

      haml :applications, :layout => !request.xhr?
    end

    get '/applications/:app_name/newest_version.json' do
      app_name = params[:app_name]
      detector = detectors.find { |det| det.basic_name == app_name }
      app = detector.new

      result = Hash.new
      result[:newest_version] = app.newest_version
      result[:project_url_for_newest_version] = app.project_url_for_newest_version

      content_type 'application/json', :charset => 'utf-8'
      result.to_json
    end

    get '/installations.json' do
      result = Hash.new

      dirs = directories
      dirs_that_dont_exist = dirs.reject { |dir| Dir.exists?(dir) }
      dirs_that_exist = dirs - dirs_that_dont_exist

      app_dirs = []
      dirs_that_exist.each do |dir|
        result_app = {}
        app = app_for_dir(dir)
        if app
          result_app[:app_name] = app.app_name
          result_app[:basic_name] = app.basic_name
          result_app[:dir] = app.base_dir
          result_app[:dir_id] = dom_id_for_dir(app.base_dir)
          result_app[:project_url] = app.project_url
        end
        app_dirs << result_app
      end
      result[:app_dirs] = app_dirs
      result[:error_dirs] = dirs_that_dont_exist

      content_type 'application/json', :charset => 'utf-8'
      result.to_json
    end

    get '/installations/:dir_id/installed_version.json' do
      dir_id = params[:dir_id]
      dir = directories.find { |d| dom_id_for_dir(d) == dir_id }
      app = app_for_dir(dir)

      return 404 unless app

      result = Hash.new
      result[:installed_version] = app.installed_version
      result[:project_url_for_installed_version] = app.project_url_for_installed_version

      content_type 'application/json', :charset => 'utf-8'
      result.to_json
    end

    get '/javascripts/:name.js' do
      @detectors = detectors
      @directories = directories.map { |d| dom_id_for_dir(d) }

      content_type 'application/javascript', :charset => 'utf-8'
      erb "javascripts/#{params[:name]}.js".to_sym
    end

    # at a minimum, the main sass file must reside within the ./views directory. here, we create a ./views/stylesheets directory where all of the sass files can safely reside.
    get '/stylesheets/:name.css' do
      content_type 'text/css', :charset => 'utf-8'
      scss "stylesheets/#{params[:name]}.css".to_sym
    end
  end
end
