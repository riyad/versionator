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

      def recognizers
        Versionator::Recognizer.all
      end
    end

    get '/' do
      @dirs = dirs
      @recognizers = recognizers
      @wares = []
      @dirs.each do |dir|
        @recognizers.each do |rec_class|
          rec = rec_class.new(dir)
          @wares << rec if rec.detected?
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
