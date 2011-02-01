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

    configure(:development) do
      register Sinatra::Reloader
      also_reload ["*.rb", "lib/**/*.rb"]
    end


    helpers do
      def ajax_loader
        %Q{<img src="ajax-loader.gif" class="ajax-loader" />}
      end

      def detectors
        Versionator::Detector.all
      end

      def dirs
        File.readlines('dirs').map(&:chomp)
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
      def toggle_container(selector, subj_state = :collapsed)
        %Q{<div class="toggle-container toggle button">} +
          %Q{<img src="images/container-expand.png" class="container-expand" />} +
          %Q{<img src="images/container-collapse.png" class="container-collapse" />} +
          %Q{<script>
  $(document).ready(function() {
    var subj = $('#{selector}');
    var subjHead = $(subj).find('.head');
    var subjBody = $(subj).find('.body');
    var button = $(subj).find('.toggle.button');
    var expand = $(subj).find('.container-expand');
    var collapse = $(subj).find('.container-collapse');

    $(button).click(function() {
      expand.toggle();
      collapse.toggle();
      subjHead.slideToggle();
      subjBody.slideToggle();
    });
    #{ if subj_state == :collapsed
        "collapse.hide();
        subjBody.hide();"
      else
        "expand.hide();
        subjHead.hide();"
    end }
  });
        </script>} +
        %Q{</div>}
      end
    end

    get '/' do
      @dirs = dirs
      @dirs_that_dont_exist = @dirs.reject { |dir| Dir.exists?(dir) }
      @dirs_that_exist = @dirs - @dirs_that_dont_exist

      @detectors = detectors.sort_by(&:app_name)

      @apps = {}
      @dirs_that_exist.each do |dir|
        @detectors.each do |detector_class|
          detector = detector_class.new(dir)
          @apps[dir] = detector if detector.detected?
        end
      end

      haml :index
    end

    get '/about' do
      haml :about
    end

    get '/apps' do
      @detectors = detectors.sort_by(&:app_name)

      haml :apps, :layout => !request.xhr?
    end

    get '/apps/:app_name/newest_version' do
      app_name = params[:app_name]
      app_class = detectors.find { |det| det.basic_name == app_name }
      app = app_class.new

      ret = Hash.new
      ret[:newest_version] = app.newest_version
      ret[:project_url_for_newest_version] = app.project_url_for_newest_version
      ret.to_json
    end

    get '/stylesheet.css' do
      sass :stylesheet
    end

    # start the server if ruby file executed directly
    run! #if app_file == $0
  end
end
