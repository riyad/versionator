module Versionator
  module Detector
    # Detects {Vanilla}[http://vanillaforums.org/]
    class Vanilla < Base
      set :app_name, "Vanilla Forums"
      set :project_url, "http://vanillaforums.org/"
      set :project_download_url, "http://vanillaforums.org/download"

      set :detect_dirs, %w{applications/vanilla conf js library themes uploads}
      set :detect_files, %w{bootstrap.php index.php}

      set :installed_version_file, "index.php"
      set :installed_version_regexp, /^define\('APPLICATION_VERSION', '(.+)'\);$/

      set :newest_version_url, 'http://vanillaforums.org/get/vanilla-core'
      set :newest_version_selector, '#Body h1'
      set :newest_version_regexp, /^Downloading: Vanilla version ([\d.]+)$/
    end
  end
end
