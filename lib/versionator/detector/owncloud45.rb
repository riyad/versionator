
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/] 4.5.
    class Owncloud45 < Base
      set :app_name, "ownCloud 4.5"
      set :project_url, "http://owncloud.org/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /^\s*return array\((\d+,\d+,\d+)\);$/

      set :newest_version_url, 'http://owncloud.org/install/'
      set :newest_version_selector, '.content .page-content h4'
      set :newest_version_regexp, /^Latest 4.5 \((.+)\)$/
      
      # Overridden to make sure that we do only detect ownCloud 4.5
      def contents_detected?
        installed_version.major == 4 && installed_version.minor >= 5 if super
      end
    end
  end
end