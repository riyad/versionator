
module Versionator
  module Detector
    # Detects {phpMyAdmin}[http://www.phpmyadmin.net].
    class Phpmyadmin < Base
      set :app_name, "phpMyAdmin"
      set :project_url, "http://www.phpmyadmin.net"

      set :detect_dirs, %w{js libraries themes}
      set :detect_files, %w{export.php index.php navigation.php README sql.php themes.php}

      set :installed_version_file, "README"
      set :installed_version_regexp, /^\s*Version (.+)$/

      set :newest_version_url, 'http://www.phpmyadmin.net/home_page/index.php'
      set :newest_version_selector, '#body .downloadbutton a'
      set :newest_version_regexp, /^Download (.+)$/
    end
  end
end
