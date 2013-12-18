
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/].
    class Owncloud < Base
      set :app_name, "ownCloud"
      set :project_url, "http://owncloud.org/"
      set :project_download_url, "http://owncloud.org/support/install/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php version.php}

      set :installed_version_file, "version.php"
      set :installed_version_regexp, /\$OC_VersionString = '(.+)'/

      set :newest_version_url, 'http://owncloud.org/changelog/'
      set :newest_version_selector, 'h3'
      set :newest_version_regexp, /^Version (6[\d\.]+a?)/

      # Overridden to make sure that we do only detect the 5+ series
      def contents_detected?
        installed_version.major >= 6 if super
      end
    end
  end
end
