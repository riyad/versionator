
module Versionator
  module Detector
    # Detects {GitLab}[http://gitlabhq.com].
    class Gitlab < Base
      set :app_name, "GitLab"
      set :project_url, "http://gitlabhq.com"

      set :detect_dirs, %w{app config lib public vendor}
      set :detect_files, %w{CHANGELOG Rakefile VERSION}

      set :installed_version_file, "VERSION"
      set :installed_version_regexp, /^(.+)$/

      set :newest_version_url, 'https://github.com/gitlabhq/gitlabhq/tags'
      set :newest_version_selector, '.download-list h4 a'
      set :newest_version_regexp, /^v(.+).zip$/

      # Overridden to make sure we detect Gitlab and not just any RoR app.
      def contents_detected?
        true if find_first_line(:matching => /Gitlab/, :in_file => "Rakefile")
      end
    end
  end
end
