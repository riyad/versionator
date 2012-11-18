module Versionator
  module Detector
    # Detects {Etherpad Lite}[http://etherpad.org/].
    class EtherpadLite < Base
      set :app_name, "Etherpad Lite"
      set :project_url, "http://etherpad.org/"

      set :detect_dirs, %w{bin doc src tools var}
      set :detect_files, %w{CHANGELOG.md README.md settings.json.template}

      set :installed_version_file, "CHANGELOG.md"
      set :installed_version_regexp, /^# v\s*(.+)$/

      set :newest_version_url, 'http://etherpad.org/'
      set :newest_version_selector, '#downloadbutton'
      set :newest_version_regexp, /Version (.+)$/

      def project_url_for_version(version)
         "https://github.com/ether/etherpad-lite/blob/master/CHANGELOG.md#v#{version.to_s.gsub('.', '')}"
      end
    end
  end
end
