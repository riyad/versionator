module Versionator
  module Detector
    # Detects {RainLoop}[http://rainloop.net/].
    class RainLoop < Base
      set :app_name, "RainLoop"
      set :project_url, "http://rainloop.net/"
      set :project_download_url, "http://rainloop.net/downloads/"

      set :detect_dirs, %w{data rainloop}
      set :detect_files, %w{index.php data/VERSION}

      set :installed_version_file, "data/VERSION"
      set :installed_version_regexp, /([\d\.]+)/

      set :newest_version_url, 'http://rainloop.net/downloads/'
      set :newest_version_selector, '.main-center a.button'
      set :newest_version_regexp, /Community edition\s+v([\d\.]+)/
    end
  end
end
