
module Versionator
  module Detector
    # Detects {MediaWiki}[http://www.mediawiki.org].
    class Mediawiki < Base
      set :app_name, "MediaWiki"
      set :project_url, "http://www.mediawiki.org"
      set :project_download_url, "http://www.mediawiki.org/wiki/Download"

      set :detect_dirs, %w{extensions images includes maintenance skins}
      set :detect_files, %w{api.php includes/DefaultSettings.php index.php thumb.php}

      set :installed_version_file, "includes/DefaultSettings.php" # see contents_detected?
      set :installed_version_regexp, /^\$wgVersion\s*= '(.+)';$/

      set :newest_version_url, 'http://www.mediawiki.org/wiki/Download'
      set :newest_version_selector, '#bodyContent .plainlinks a'
      set :newest_version_regexp, /^Download MediaWiki (.+)$/
    end
  end
end
