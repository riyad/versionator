
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/].
    class Owncloud < Base
      set :app_name, "ownCloud"
      set :project_url, "http://owncloud.org/"
      set :project_download_url, "http://owncloud.org/install/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php version.php}

      set :installed_version_file, "version.php"
      set :installed_version_regexp, /\$OC_VersionString = '(.+)'/

      set :newest_version_url, 'http://owncloud.org/install/'
      set :newest_version_selector, '.install .main p'
      set :newest_version_regexp, /^Latest stable version: (7[\d\.]+)/

      # Overridden to make sure that we do only detect the 5+ series
      def contents_detected?
        installed_version.major >= 7 if super
      end
    end
  end
end
