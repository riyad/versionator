
module Versionator
  module Detector
    # Detects {Versionator}[https://github.com/riyad/versionator].
    class Versionator < Base
      set :app_name, "Versionator"
      set :project_url, "https://github.com/riyad/versionator"
      set :project_download_url, "https://github.com/riyad/versionator/tags"

      set :detect_dirs, %w{doc lib public tmp views}
      set :detect_files, %w{versionator.rb VERSION}

      set :installed_version_file, "VERSION"
      set :installed_version_regexp, /^(.+)$/

      set :newest_version_url, 'https://github.com/riyad/versionator/tags'
      set :newest_version_selector, 'h3 .tag-name'
      set :newest_version_regexp, /^v(.+)$/
    end
  end
end
