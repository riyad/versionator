
require 'haml'
require 'json'
require 'sinatra/base'
require 'sinatra/reloader'

require 'versionator/detector'

module Versionator
  class Application < Sinatra::Base

    configure do
      # the name of the file containing the directories to be checked
      set :check_dirs, "check_dirs"

      set :public, 'public'
    end

    configure(:development) do
      register Sinatra::Reloader
      also_reload ["*.rb", "lib/**/*.rb"]
    end



    helpers do
      # Inserts a throbber image which will be hidden by default.
      # The image will have the +ajax-loader+ class.
      def ajax_loader
        %Q{<img src="ajax-loader.gif" class="ajax-loader" />}
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
        %Q{<img src="images/#{name}.png" alt="#{name}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]}/>}
      end

      # Instert a link to _href_ showing the given _text_.
      # You can add html options using the _html_options_ hash.
      def link_to(text, href, html_options = {})
        %Q{<a href="#{href}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]}>} +
          text +
        %Q{</a> }
      end

      def link_to_app_project(app)
        link_to_external("#{mini_logo_for(app)} #{app.app_name} Website", app.project_url)
      end

      def link_to_app_release(app, version)
        version_method = version.to_sym
        url_method = "project_url_for_#{version.to_s}".to_sym
        link_to_external("#{image("link")} #{app.send(version_method)} Release", app.send(url_method), :class => version_method.to_s)
      end

      def link_to_external(text, href, html_options = {})
        %Q{<a href="#{href}" #{%Q{id="#{html_options[:id]}"} if html_options[:id]} #{%Q{class="#{html_options[:class]}"} if html_options[:class]}>} +
          text +
          image("link-external", :class => "link-external") +
        %Q{</a> }
      end

      # Inserts the (big) logo for the given _detector_.
      def logo_for(detector)
        logo(detector.basic_name)
      end

      def logo(basic_name)
        %Q{<img src="logos/#{basic_name}.png" alt="#{basic_name}" />}
      end

      # Inserts the mini logo for the given _detector_.
      def mini_logo_for(detector)
        logo("#{detector.basic_name}-mini")
      end

      # Inserts buttons to toggle the expansion/collapse of the element represented by _subj_selector_.
      # This must be inserted as a decendant of the subject element.
      # The subject must have +.head+ and +.body+ decendants.
      # You can also specify the initial state of the subject element using the _initial_subj_state_ param with either the +:collapsed+ or +:expanded+ values.
      def toggle_container(subj_selector, initial_subj_state = :collapsed)
        %Q{<div class="toggle-container toggle button">} +
          image("container-expand", :class => "container-expand") +
          image("container-collapse", :class => "container-collapse") +
          %Q{<script>
            $(document).ready(function() {
              setupToggleContainer("#{subj_selector}", "#{initial_subj_state}");
            });
        </script>} +
        %Q{</div>}
      end
    end



    get '/' do
      @apps = detectors
      @dirs = directories.sort

      haml :index
    end

    get '/about' do
      haml :about
    end

    get '/apps' do
      all_apps = detectors
      installs_for_app = Hash.new([])
      directories.each do |dir|
        all_apps.each do |app_class|
          app = app_class.new(dir)
          installs_for_app[app_class] += [app] if app.detected?
        end
      end

      # only show apps that have actual installs
      @apps = installs_for_app.keys.sort_by(&:basic_name)
      @installs_for_app = installs_for_app

      haml :apps, :layout => !request.xhr?
    end

    get '/apps/:app_name/newest_version.json' do
      app_name = params[:app_name]
      detector = detectors.find { |det| det.basic_name == app_name }
      app = detector.new

      result = Hash.new
      result[:newest_version] = app.newest_version
      result[:project_url_for_newest_version] = app.project_url_for_newest_version

      result.to_json
    end

    get '/installations' do
      @dirs = directories
      @dirs_that_dont_exist = @dirs.reject { |dir| Dir.exists?(dir) }
      @dirs_that_exist = @dirs - @dirs_that_dont_exist

      @detectors = detectors

      @apps = {}
      @dirs_that_exist.each do |dir|
        @detectors.each do |detector_class|
          detector = detector_class.new(dir)
          @apps[dir] = detector if detector.detected?
        end
      end

      haml :installations, :layout => !request.xhr?
    end

    get '/javascript.js' do
      @detectors = detectors

      erb "javascript.js".to_sym
    end

    get '/stylesheet.css' do
      sass :stylesheet
    end
  end
end
