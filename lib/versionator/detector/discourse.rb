
module Versionator
  module Detector
    # Detects {Discourse}[http://www.discourse.org/]
    class Discourse < Base
      set :app_name, "Discourse"
      set :project_url, "http://www.discourse.org/"
      set :project_download_url, "https://github.com/discourse/discourse/releases"

      set :detect_dirs, %w{app config lib public vendor}
      set :detect_files, %w{lib/version.rb Rakefile README.md}

      set :installed_version_file, "lib/version.rb"
      set :installed_version_regexp, /MAJOR = (\d)\s+MINOR = (\d)\s+TINY  = (\d)\s+PRE   = (\d)?/m

      set :newest_version_url, 'https://github.com/discourse/discourse/releases'
      set :newest_version_selector, 'h3 .tag-name'
      set :newest_version_regexp, /^v(.+)$/

      def contents_detected?
        # Overridden to make sure we detect Discourse and not any RoR app.
        super && find_first_match(:matching => /Discourse$/, :in_file => "lib/version.rb")
      end
    end
  end
end
