
module Versionator
  module Detector
    # Detects {Trac}[http://trac.edgewall.org].
    class TracCurrent < Base
      set :app_name, "Trac"
      set :project_url, "http://trac.edgewall.org"
      set :project_download_url, "http://trac.edgewall.org/wiki/TracDownload#LatestStableRelease"

      set :detect_dirs, %w{contrib doc trac}
      set :detect_files, %w{PKG-INFO setup.cfg setup.py tracini.cfg}

      set :installed_version_file, "PKG-INFO"
      set :installed_version_regexp, /^Version: (1\.[\d\.]+)$/

      set :newest_version_url, 'http://trac.edgewall.org/wiki/TracDownload'
      set :newest_version_selector, '#LatestStableRelease'
      set :newest_version_regexp, /^.+ - Trac (1\.[\d\.]+)$/
    end
  end
end
