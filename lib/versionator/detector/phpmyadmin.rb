
module Versionator
  module Detector
    # Detects {phpMyAdmin}[http://www.phpmyadmin.net].
    class Phpmyadmin < Base
      set :app_name, "phpMyAdmin"
      set :project_url, "http://www.phpmyadmin.net"

      set :detect_dirs, %w{contrib js libraries pmd scripts themes}
      set :detect_files, %w{export.php index.php main.php navigation.php README sql.php themes.php}

      set :installed_version_file, "README"
      set :installed_version_regexp, /^\s*Version (.+)$/

      set :newest_version_url, 'http://www.phpmyadmin.net/home_page/index.php'
      set :newest_version_selector, '#body .rightbuttons .downloadbutton .dlname a'
      set :newest_version_regexp, /^Download (.+)$/

      def project_url_for_version(version)
        if version >= Versionomy.parse('3.3.9')
          "http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/#{version}/phpMyAdmin-#{version}.html/view"
        else
          "http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/#{version}/phpMyAdmin-#{version}-notes.html/view"
        end
      end
    end
  end
end
