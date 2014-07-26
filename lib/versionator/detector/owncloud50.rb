
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/] 5.0.
    # This will also detect installed versions prior to the 5.0 series.
    # But it will only check for the most recent version of the 5.0 series.
    class Owncloud50 < Base
      set :app_name, "ownCloud 5.0"
      set :project_url, "http://owncloud.org/"
      set :project_download_url, "http://owncloud.org/install/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /return '(\d+\.\d+(?:\.\d+)?).*';$/

      set :newest_version_url, 'http://owncloud.org/changelog/'
      set :newest_version_selector, 'h3'
      set :newest_version_regexp, /^Version (5\.[\d\.]+)/

      # Overridden to make sure that we do only detect the 5.0 and lower series
      def contents_detected?
        installed_version.major <= 5 if super
      end
    end
  end
end
