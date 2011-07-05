
module Versionator
  module Detector
    # Detects {EGroupware}[http://www.egroupware.org].
    class Egroupware < Base
      set :app_name, "EGroupware"
      set :project_url, "http://www.egroupware.org"

      set :detect_dirs, %w{addressbook admin bookmarks calendar filemanager home polls preferences resources setup tracker wiki}
      set :detect_files, %w{admin/setup/setup.inc.php groupdav.php index.php login.php logout.php redirect.php rpc.php webdav.php xajax.php xmlrpc.php}

      set :installed_version_file, "admin/setup/setup.inc.php"
      set :installed_version_regexp, /^\$setup_info\['admin'\]\['version'\]\s+= '(.+)';$/

      set :newest_version_url, 'http://www.egroupware.org/download'
      set :newest_version_selector, '.contentpane h3'
      set :newest_version_regexp, /^\s*Current release: (.+)$/

      # Overridden to get the full version number on the 2nd round.
      # Initial detection only gets major and minor version numbers.
      def detect_installed_version
        super

        detailed_version_file = "doc/rpm-build/egroupware-#{installed_version}.spec"
        detailed_version_regexp = /^Version: (.+)$/

        version_line = find_first_line(:matching => detailed_version_regexp, :in_file => detailed_version_file)

        version = extract_version(:from => version_line, :with => detailed_version_regexp)
        version = Versionomy.parse(version)
        @installed_version = version.change({ :tiny2 => 0 }, :optional_fields => [:tiny, :tiny2])
      end

      def project_url_for_version(version)
        "#{project_url}/wiki?wikipage=releasenotes#{version.major}.#{version.minor}"
      end
    end
  end
end
