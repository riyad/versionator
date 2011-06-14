
module Versionator
  module Detector
    # Detects {ownCloud1}[http://owncloud.org/index.php/Main_Page].
    class Owncloud < Base
      set :app_name, "ownCloud"
      set :project_url, "http://owncloud.org/index.php/Main_Page"

      set :detect_dirs, %w{admin config css docs files img inc js log ocs plugins settings webdav}
      set :detect_files, %w{db_structure.xml inc/lib_base.php index.php README}

      set :installed_version_file, "inc/lib_base.php"
      set :installed_version_regexp, /^\s*return array\((\d,\d,\d)\);$/

      set :newest_version_url, 'http://owncloud.org/index.php/Installation'
      set :newest_version_selector, 'div#bodyContent ol ul a.external'
      set :newest_version_regexp, /^stable version (.+)$/

      # Overridden because
      # * Versionator cannot handle comma as version delimiter
      # * the tiny version number may need to be cut
      def detect_installed_version
        return @installed_version unless self.class.method_defined?(:installed_version_file)

        version_line = find_first_line(:matching => installed_version_regexp, :in_file => installed_version_file)

        version = extract_version(:from => version_line, :with => installed_version_regexp)

        # fix version string
        version.gsub!(',', '.')

        if version
          # parse including tiny version
          version = Versionomy.parse(version)
          # remove tiny version if 0
          @installed_version = version.change({}, :optional_fields => [:tiny])
        end
      end
    end
  end
end
