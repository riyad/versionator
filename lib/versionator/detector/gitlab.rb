
module Versionator
  module Detector
    # Detects {GitLab}[http://gitlabhq.com].
    class Gitlab < Base
      set :app_name, "GitLab"
      set :project_url, "http://gitlabhq.com"

      set :detect_dirs, %w{app config lib public vendor}
      set :detect_files, %w{CHANGELOG Rakefile README.rdoc}

      set :installed_version_file, "CHANGELOG"
      set :installed_version_regexp, /^v (.+)$/

      set :newest_version_url, 'http://gitlabhq.com/releases.html'
      set :newest_version_selector, 'h2'
      set :newest_version_regexp, /^Latest version is '.*' ([\d.]+)/

      # Overridden to make sure we detect GitLab and not just any RoR app.
      def contents_detected?
        true if find_first_line(:matching => /GitLab/, :in_file => "README.rdoc")
      end

      def project_url_for_version(version)
        "http://gitlabhq.com/releases.html"
      end
    end
  end
end
