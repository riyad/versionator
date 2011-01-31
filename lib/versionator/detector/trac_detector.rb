
module Versionator
  module Detector
    class TracDetector < Base
      set :basic_name, "trac"
      set :app_name, "Trac"
      set :project_url, "http://trac.edgewall.org"

      set :detect_dirs, %w{cgi-bin contrib trac wiki-macros}
      set :detect_files, %w{PKG-INFO setup.cfg setup.py}

      set :installed_version_file, "PKG-INFO"
      set :installed_version_regexp, /^Version: (.+)$/

      set :newest_version_url, 'http://trac.edgewall.org/wiki/TracDownload'
      set :newest_version_selector, 'h2#LatestStableRelease'
      set :newest_version_regexp, /^.+ - (.+)$/

      def project_url_for_version(version)
        "#{project_url}/browser/tags/trac-#{version}/RELEASE"
      end
    end
  end
end
