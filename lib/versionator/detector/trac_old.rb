
module Versionator
  module Detector
    # Detects {Trac}[http://trac.edgewall.org].
    class TracOld < Base
      set :app_name, "Trac (LTS)"
      set :project_url, "http://trac.edgewall.org"

      set :detect_dirs, %w{contrib doc trac}
      set :detect_files, %w{PKG-INFO setup.cfg setup.py}

      set :installed_version_file, "PKG-INFO"
      set :installed_version_regexp, /^Version: (.+)$/

      set :newest_version_url, 'http://trac.edgewall.org/wiki/TracDownload'
      set :newest_version_selector, '#PreviousStableRelease'
      set :newest_version_regexp, /^.+ - Trac (.+)$/

      def contents_detected?
        super && installed_version.major == 0
      end

      def project_url_for_version(version)
        "#{project_url}/browser/tags/trac-#{version}/RELEASE"
      end
    end
  end
end
