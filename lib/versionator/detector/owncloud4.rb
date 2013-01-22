
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/] 4.0.
    # This will also detect installed Drupal versions prior to the 4.0 series.
    # But it will only check for the most recent version of the 4.0 series.
    class Owncloud4 < Base
      set :app_name, "ownCloud"
      set :project_url, "http://owncloud.org/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /return '(\d+\.\d+(\.\d+)?).*';$/

      set :newest_version_url, 'http://owncloud.org/install/'
      set :newest_version_selector, '.content h4'
      set :newest_version_regexp, /^Latest 4.0 \(([\d\.]+)\)/

      # Overridden to make sure that we do only detect ownCloud 4.0 or previous
      def contents_detected?
        installed_version.major < 4 || (installed_version.major == 4 && installed_version.minor < 5) if super
      end
    end
  end
end
