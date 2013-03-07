
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/] 4.5.
    class Owncloud45 < Base
      set :app_name, "ownCloud 4.5"
      set :project_url, "http://owncloud.org/"

      set :detect_dirs, %w{apps core lib ocs settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /return '(\d+\.\d+(\.\d+)?).*';$/

      set :newest_version_url, 'http://owncloud.org/support/install/'
      set :newest_version_selector, '.content h1'
      set :newest_version_regexp, /^Install ownCloud Server ([\d\.]+)/
      
      # Overridden to make sure that we do only detect ownCloud 4.0 or previous
      def contents_detected?
        installed_version.major > 4 || (installed_version.major == 4 && installed_version.minor >= 5) if super
      end
    end
  end
end
