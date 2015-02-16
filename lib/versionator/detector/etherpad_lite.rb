module Versionator
  module Detector
    # Detects {Etherpad Lite}[http://etherpad.org/].
    class EtherpadLite < Base
      set :app_name, "Etherpad Lite"
      set :project_url, "http://etherpad.org/"
      set :project_download_url, "http://etherpad.org/#download"

      set :detect_dirs, %w{bin doc src var}
      set :detect_files, %w{CHANGELOG.md README.md settings.json.template}

      set :installed_version_file, "CHANGELOG.md"
      set :installed_version_regexp, /^# v?\s?(.+)$/

      set :newest_version_url, 'http://etherpad.org/'
      set :newest_version_selector, '.button'
      set :newest_version_regexp, /Version (.+)$/
    end
  end
end
