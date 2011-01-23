#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'

require 'haml'
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

      def dirs
        File.readlines('dirs').map(&:chomp)
      end

      def logo_for(detector)
        logo(detector.basic_name)
      end

      def image(name)
        %Q{<img src="images/#{name}.png" alt="#{name}" />}
      end

      def logo(basic_name)
        %Q{<img src="logos/#{basic_name}.png" alt="#{basic_name}" />}
      end

      def detectors
        Versionator::Detector.all
      end

      # must be sibling of toggle item
      def toggle_container(selector)
        %Q{<div class="toggle-container">} +
        %Q{<img src="images/container-show.png" class="show-container" />} +
        %Q{<img src="images/container-hide.png" class="hide-container" />} +
        %Q{<script>
  $(document).ready(function() {
    var subj = $('#{selector}');
    var cont = $('#{selector}').siblings('.toggle-container');
    var show = cont.find('.show-container');
    var hide = cont.find('.hide-container');

    cont.click(function() {
      show.toggle();
      hide.toggle();
      subj.slideToggle();
    });
    subj.hide();
    hide.hide();
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

      @installations = {}
      @dirs_that_exist.each do |dir|
        recognized_installations = []
        @detectors.each do |detector_class|
          detector = detector_class.new(dir)
          recognized_installations << detector if detector.detected?
          @installations[dir] = recognized_installations
        end
      end

      haml :index
    end

    get '/apps/:app_name/newest_version' do
      app_name = params[:app_name]
      app_class = detectors.find { |det| det.basic_name == app_name }
      app_class.new.newest_version
    end

    get '/stylesheet.css' do
      sass :stylesheet
    end

    # start the server if ruby file executed directly
    run! #if app_file == $0
  end
end
