
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/].
    class Owncloud < Base
      set :app_name, "ownCloud"
      set :project_url, "https://owncloud.org/"
      set :project_download_url, "https://owncloud.org/install/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php version.php}

      set :installed_version_file, "version.php"
      set :installed_version_regexp, /\$OC_VersionString = '(.+)'/

      set :newest_version_url, 'https://owncloud.org/install/'
      set :newest_version_selector, '#instructions-server p'
      set :newest_version_regexp, /^Latest stable version:\s+([\d\.]+)/
    end
  end
end
