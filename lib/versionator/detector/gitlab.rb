
module Versionator
  module Detector
    # Detects {GitLab}[http://gitlabhq.com].
    class Gitlab < Base
      set :app_name, "GitLab"
      set :project_url, "http://gitlabhq.org"
      set :project_download_url, "https://github.com/gitlabhq/gitlabhq/tags"

      set :detect_dirs, %w{app config lib public vendor}
      set :detect_files, %w{CHANGELOG Rakefile VERSION}

      set :installed_version_file, "VERSION"
      set :installed_version_regexp, /^(.+)$/

      set :newest_version_url, 'https://github.com/gitlabhq/gitlabhq/blob/stable/VERSION'
      set :newest_version_selector, '#files .highlight pre'
      set :newest_version_regexp, /^(.+)$/

      # Overridden to make sure we detect Gitlab and not just any RoR app.
      def contents_detected?
        true if find_first_line(:matching => /Gitlab/, :in_file => "Rakefile")
      end
    end
  end
end
