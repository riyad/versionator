#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'

require 'haml'
require 'json'
require 'sinatra/reloader'

require File.expand_path('../lib/versionator', __FILE__)

module Versionator
  class Application < Sinatra::Base
    set :app_file, __FILE__

    configure do
      # the name of the file containing the directories to be checked
      set :check_dirs, "check_dirs"
    end

    configure(:development) do
      register Sinatra::Reloader
      also_reload ["*.rb", "lib/**/*.rb"]
    end



    helpers do
      def ajax_loader
        %Q{<img src="ajax-loader.gif" class="ajax-loader" />}
      end

      def detectors
        Versionator::Detector.all.sort_by(&:basic_name)
      end

      def dirs
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
        expanded_dirs.flatten.sort_by(&:downcase)
      end

      def dom_id_for_dir(dir)
        dir.gsub(/(\/|\.)/, '-')
      end

      def image(name)
        %Q{<img src="images/#{name}.png" alt="#{name}" />}
      end

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
          %Q{ <img src="images/link-external.png" class="link-external" />} +
        %Q{</a> }
      end

      def logo_for(detector)
        logo(detector.basic_name)
      end

      def logo(basic_name)
        %Q{<img src="logos/#{basic_name}.png" alt="#{basic_name}" />}
      end

      def mini_logo(basic_name)
        %Q{<img src="logos/#{basic_name}-mini.png" alt="#{basic_name}" />}
      end

      def mini_logo_for(detector)
        mini_logo(detector.basic_name)
      end

      # must be decendant of subject
      # subject must have .head and .body decendants
      def toggle_container(subj_selector, initial_subj_state = :collapsed)
        %Q{<div class="toggle-container toggle button">} +
          %Q{<img src="images/container-expand.png" class="container-expand" />} +
          %Q{<img src="images/container-collapse.png" class="container-collapse" />} +
          %Q{<script>
            $(document).ready(function() {
              setupToggleContainer("#{subj_selector}", "#{initial_subj_state.to_s}");
            });
        </script>} +
        %Q{</div>}
      end
    end



    get '/' do
      @apps = detectors
      @dirs = dirs.sort

      haml :index
    end

    get '/about' do
      haml :about
    end

    get '/apps' do
      all_apps = detectors
      installs_for_app = Hash.new([])
      dirs.each do |dir|
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
      app_class = detectors.find { |det| det.basic_name == app_name }
      app = app_class.new

      ret = Hash.new
      ret[:newest_version] = app.newest_version
      ret[:project_url_for_newest_version] = app.project_url_for_newest_version
      ret.to_json
    end

    get '/installations' do
      @dirs = dirs
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

    # start the server if ruby file executed directly
    run! #if app_file == $0
  end
end
