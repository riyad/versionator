
module Versionator
  module Detector
    class Phpmyadmin < Base
      set :app_name, "phpMyAdmin"
      set :project_url, "http://www.phpmyadmin.net"

      set :detect_dirs, %w{contrib js lang libraries pmd scripts themes}
      set :detect_files, %w{ChangeLog error.php export.php index.php main.php navigation.php sql.php themes.php}

      set :installed_version_file, "ChangeLog"
      set :installed_version_regexp, /^(\d.+) \(\d\d\d\d-\d\d-\d\d\)$/

      set :newest_version_url, 'http://www.phpmyadmin.net/home_page/index.php'
      set :newest_version_selector, '#body .rightbuttons .downloadbutton .dlname a'
      set :newest_version_regexp, /^Download (.+)$/

      def installed_version
        Versionomy.parse(super.unparse(:optional_fields => [:tiny, :tiny2]))
      end

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
