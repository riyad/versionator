
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/].
    class Owncloud < Base
      set :app_name, "ownCloud"
      set :project_url, "http://owncloud.org/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /return '(\d+\.\d+(\.\d+)?).*';$/

      set :newest_version_url, 'http://owncloud.org/support/install/'
      set :newest_version_selector, 'h1'
      set :newest_version_regexp, /ownCloud Server ([\d\.]+)$/

      # Overridden to make sure that we do only detect the 5+ series
      def contents_detected?
        installed_version.major > 4 if super
      end

      # Overridden to make the minor version number optional
      def detect_installed_version
        super
        @installed_version = @installed_version.change({}, :optional_fields => [:minor, :tiny])
      end
    end
  end
end
