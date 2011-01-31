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

    # from actionpack/lib/action_view/helpers/javascript_helper.rb
    JS_ESCAPE_MAP = {
      '\\'    => '\\\\',
      '</'    => '<\/',
      "\r\n"  => '\n',
      "\n"    => '\n',
      "\r"    => '\n',
      '"'     => '\\"',
      "'"     => "\\'"
    }

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

      # from actionpack/lib/action_view/helpers/javascript_helper.rb
      def escape_javascript(javascript)
        if javascript
          javascript.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
        else
          ''
        end
      end

      def image(name)
        %Q{<img src="images/#{name}.png" alt="#{name}" />}
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
      def toggle_container(selector, subj_state = :head)
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
    #{ if subj_state == :head
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
