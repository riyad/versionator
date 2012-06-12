
module Versionator
  module Detector
    # Detects {Etherpad Lite}[http://etherpad.org/].
    class EtherpadLite < Base
      set :app_name, "Etherpad Lite"
      set :project_url, "http://etherpad.org/"

      set :detect_dirs, %w{bin doc src static}
      set :detect_files, %w{CHANGELOG.md README.md settings.json.template}

      set :installed_version_file, "CHANGELOG.md"
      set :installed_version_regexp, /^# v (.+)$/

      set :newest_version_url, 'https://github.com/Pita/etherpad-lite/blob/master/CHANGELOG.md'
      set :newest_version_selector, '#files .blob article h1'
      set :newest_version_regexp, /^v (.+)$/

      def project_url_for_version(version)
         "https://github.com/Pita/etherpad-lite"
      end
    end
  end
end
