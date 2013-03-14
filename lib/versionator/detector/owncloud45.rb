
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/] 4.5.
    # This will also detect installed versions of the 4.5 series.
    # It will only check for the most recent version of the 4.5 series.
    class Owncloud45 < Base
      set :app_name, "ownCloud 4.5"
      set :project_url, "http://owncloud.org/"

      set :detect_dirs, %w{apps core lib ocs settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /return '(\d+\.\d+(\.\d+)?).*';$/

      set :newest_version_url, 'http://owncloud.org/support/install/'
      set :newest_version_selector, '.content small a'
      set :newest_version_regexp, /^ownCloud Server (4\.5\.[\d]+)/
      
      # Overridden to make sure that we do only detect the 4.5 series
      def contents_detected?
        installed_version.major == 4 && installed_version.minor >= 5 if super
      end
    end
  end
end
