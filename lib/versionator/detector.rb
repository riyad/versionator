
require 'active_support'
include ActiveSupport::Inflector

require 'versionator/detector/base'

module Versionator
  module Detector
    # Returns an array of all the known detector classes.
    def self.all
      detectors = []

      # find all detector scripts
      Dir.glob(File.expand_path('../detector/*.rb', __FILE__)) do |det_file|
        # require script
        require det_file

        # add detector class to list
        det_name = 'versionator/'+det_file[(File.dirname(__FILE__)).size+1..-4]
        detectors << det_name.camelize.constantize unless det_name.end_with?("/base")
      end

      detectors
    end
  end
end
