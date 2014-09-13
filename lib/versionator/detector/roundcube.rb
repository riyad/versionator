
module Versionator
  module Detector
    # Detects {Roundcube}[http://roundcube.net/].
    class Roundcube < Base
      set :app_name, "Roundcube"
      set :project_url, "http://roundcube.net/"
      set :project_download_url, "http://roundcube.net/download"

      set :detect_dirs, %w{bin config installer plugins program skins}
      set :detect_files, %w{index.php}

      set :installed_version_file, "index.php"
      set :installed_version_regexp, /^ \| Version ([^ ]+)\s+\|$/

      set :newest_version_url, 'http://roundcube.net/download/'
      set :newest_version_selector, '#main .dltable .dlversion'
      set :newest_version_regexp, /^Complete: (.+)$/
    end
  end
end
