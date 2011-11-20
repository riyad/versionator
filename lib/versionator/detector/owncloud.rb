
module Versionator
  module Detector
    # Detects {ownCloud}[http://owncloud.org/].
    class Owncloud < Base
      set :app_name, "ownCloud"
      set :project_url, "http://owncloud.org/"

      set :detect_dirs, %w{3rdparty apps core lib settings}
      set :detect_files, %w{db_structure.xml index.php lib/util.php README}

      set :installed_version_file, "lib/util.php"
      set :installed_version_regexp, /^\s*return array\((\d+,\d+,\d+)\);$/

      set :newest_version_url, 'http://owncloud.org/'
      set :newest_version_selector, '#content .entry-content a'
      set :newest_version_regexp, /^download ownCloud (.+)$/

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
          @installed_version = version.change({}, :optional_fields => [:minor, :tiny])
        end
      end
    end
  end
end
