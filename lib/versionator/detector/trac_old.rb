
module Versionator
  module Detector
    # Detects {Trac}[http://trac.edgewall.org].
    class TracOld < Base
      set :app_name, "Trac (LTS)"
      set :project_url, "http://trac.edgewall.org"
      set :project_download_url, "http://trac.edgewall.org/wiki/TracDownload#PreviousStableRelease"

      set :detect_dirs, %w{contrib doc trac wiki-macros}
      set :detect_files, %w{PKG-INFO setup.cfg setup.py}

      set :installed_version_file, "PKG-INFO"
      set :installed_version_regexp, /^Version: (0\.[\d\.]+)$/

      set :newest_version_url, 'http://trac.edgewall.org/wiki/TracDownload'
      set :newest_version_selector, '#PreviousStableRelease'
      set :newest_version_regexp, /^.+ - Trac (0\.[\d\.]+)$/
    end
  end
end
