
module Versionator
  module Detector
    # Detects {Piwik}[http://piwik.org].
    class Piwik < Base
      set :app_name, "Piwik"
      set :project_url, "http://piwik.org"

      set :detect_dirs, %w{config core js libs misc plugins themes}
      set :detect_files, %w{core/Version.php index.php piwik.php}

      set :installed_version_file, "core/Version.php"
      set :installed_version_regexp, /^\sconst VERSION = '(.+)';$/

      set :newest_version_url, 'http://piwik.org/'
      set :newest_version_selector, '.download-button .title'
      set :newest_version_regexp, /^\s*Download Piwik (.+)\s*$/

      def project_url_for_version(version)
        "#{project_url}/blog/piwik-#{version.to_s.gsub('.','-')}/"
      end
    end
  end
end
