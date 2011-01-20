#!/usr/bin/env ruby

require 'sinatra/base'

require 'haml'
require 'sinatra/reloader'

require File.expand_path('lib/versionator', File.dirname(__FILE__))

module Versionator
  class Application < Sinatra::Base
    set :app_file, __FILE__

    configure(:development) do
      register Sinatra::Reloader
      also_reload ["*.rb", "lib/**/*.rb"]
    end


    helpers do
      def dirs
        File.readlines('dirs').map { |dir| dir.chomp }
      end

      def logo_for(recognizer)
        logo(recognizer.basic_name)
      end

      def image(name)
        %Q{<img src="images/#{name}.png" alt="#{name}" />}
      end

      def logo(basic_name)
        %Q{<img src="logos/#{basic_name}.png" alt="#{basic_name}" />}
      end

      def recognizers
        Versionator::Recognizer.all
      end
    end

    get '/' do
      @dirs = dirs
      @dirs_that_dont_exist = @dirs.reject { |dir| Dir.exists?(dir) }
      @dirs_that_exist = @dirs - @dirs_that_dont_exist

      @recognizers = recognizers
      @installations = {}

      @dirs_that_exist.each do |dir|
        recognized_installations = []
        @recognizers.each do |recognizer_class|
          recognizer = recognizer_class.new(dir)
          recognized_installations << recognizer if recognizer.detected?
          @installations[dir] = recognized_installations
        end
      end

      haml :index
    end

    get '/stylesheet.css' do
      sass :stylesheet
    end

    # start the server if ruby file executed directly
    run! #if app_file == $0
  end
end
