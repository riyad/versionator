
module Versionator
  module Detector
    class ReviewboardDetector < Base
      set :basic_name, "reviewboard"
      set :app_name, "Review Board"
      set :project_url, "http://www.reviewboard.org"

      set :detect_dirs, %w{contrib docs reviewboard}
      set :detect_files, %w{ez_setup.py PKG-INFO setup.cfg setup.py}

      set :installed_version_file, "PKG-INFO"
      set :installed_version_regexp, /^Version: (.+)$/

      set :newest_version_url, 'http://www.reviewboard.org/'
      set :newest_version_selector, '#announcebox p'
      set :newest_version_regexp, /^\s*Stable:\s+([^\s]+)\s*$/

      def project_url_for_version(version)
        "#{project_url}/docs/releasenotes/dev/reviewboard/#{version}/"
      end
    end
  end
end