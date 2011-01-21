
require 'active_support'
include ActiveSupport::Inflector

require File.expand_path("../recognizer/base", __FILE__)

module Versionator
  module Recognizer
    def self.all
      recognizers = []

      # find all recognizer scripts
      Dir.glob(File.dirname(__FILE__) + '/recognizer/*_recognizer.rb') do |rec_file|
        # require script
        require rec_file

        # add recognizer class to list
        rec_name = 'versionator/'+rec_file[(File.dirname(__FILE__)).size+1..-4]
        recognizers << rec_name.camelize.constantize
      end

      recognizers
    end
  end
end
