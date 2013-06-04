
module Versionator
  module Detector
    # Detects {Review Board}[http://www.reviewboard.org].
    class Reviewboard < Base
      set :app_name, "Review Board"
      set :project_url, "http://www.reviewboard.org"
      set :project_download_url, "http://www.reviewboard.org/downloads/download/"

      set :detect_dirs, %w{contrib docs reviewboard}
      set :detect_files, %w{ez_setup.py PKG-INFO setup.cfg setup.py}

      set :installed_version_file, "PKG-INFO"
      set :installed_version_regexp, /^Version: (.+)$/

      set :newest_version_url, 'http://www.reviewboard.org/'
      set :newest_version_selector, '.top-downloads a'
      set :newest_version_regexp, /^\s+Download Review Board v(.+)\s+$/
    end
  end
end
