
require 'active_support'
include ActiveSupport::Inflector

require File.expand_path("../detector/base", __FILE__)

module Versionator
  module Detector
    def self.all
      detectors = []

      # find all recognizer scripts
      Dir.glob(File.dirname(__FILE__) + '/detector/*_detector.rb') do |det_file|
        # require script
        require det_file

        # add recognizer class to list
        det_name = 'versionator/'+det_file[(File.dirname(__FILE__)).size+1..-4]
        detectors << det_name.camelize.constantize
      end

      detectors
    end
  end
end
