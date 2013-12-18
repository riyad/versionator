
module Versionator
  module Detector
    # Detects {Piwik}[http://piwik.org].
    class Piwik < Base
      set :app_name, "Piwik"
      set :project_url, "http://piwik.org"
      set :project_download_url, "http://piwik.org/download/"

      set :detect_dirs, %w{config core js libs misc plugins}
      set :detect_files, %w{core/Version.php index.php piwik.php}

      set :installed_version_file, "core/Version.php"
      set :installed_version_regexp, /^\s*const VERSION = '(.+)';$/

      set :newest_version_url, 'http://piwik.org/download/'
      set :newest_version_selector, '#startDownloadButton'
      set :newest_version_regexp, /Download Piwik ([\d\.]+)/
    end
  end
end
