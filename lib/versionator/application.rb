
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
      require 'sinatra/reloader'
      register Sinatra::Reloader
      also_reload "*.rb"
      also_reload "lib/**/*.rb"
    end



    helpers do
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
        %Q{<img src="img/#{name}.png" alt="#{name}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]} #{%Q{style="#{html_options[:style]}"} if html_options[:style]}/>}
      end

      # Instert a link to _href_ showing the given _text_.
      # You can add html options using the _html_options_ hash.
      def link_to(text, href, html_options = {})
        %Q{<a href="#{href}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]}>} +
          text +
        %Q{</a> }
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

    get '/applications/:app_name/newest_version.json' do
      app_name = params[:app_name]
      detector = detectors.find { |det| det.basic_name == app_name }
      app = detector.new

      result = Hash.new
      result[:newest_version] = app.newest_version

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
          result_app[:project_download_url] = app.project_download_url
        else
          result_app[:dir] = dir
          result_app[:unrecognized] = true
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

      content_type 'application/json', :charset => 'utf-8'
      result.to_json
    end

    # at a minimum, the main sass file must reside within the ./views directory. here, we create a ./views/stylesheets directory where all of the sass files can safely reside.
    get '/css/:name.css' do
      content_type 'text/css', :charset => 'utf-8'
      scss "css/#{params[:name]}".to_sym
    end
  end
end
