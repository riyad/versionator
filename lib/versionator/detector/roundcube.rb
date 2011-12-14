
module Versionator
  module Detector
    # Detects {Roundcube}[http://roundcube.net/].
    class Roundcube < Base
      set :app_name, "Roundcube"
      set :project_url, "http://roundcube.net/"

      set :detect_dirs, %w{bin config installer plugins program skins}
      set :detect_files, %w{index.php}

      set :installed_version_file, "index.php"
      set :installed_version_regexp, /^ \| Version ([^ ]+)\s+\|$/

      set :newest_version_url, 'http://roundcube.net/'
      set :newest_version_selector, '#main a.downloadButton'
      set :newest_version_regexp, /^Version (.+) \(.+\)$/

      def project_url_for_version(version)
        if version < Versionomy.parse('0.5')
          "http://sourceforge.net/projects/roundcubemail/files/roundcubemail/#{version}/release_notes_#{version}.txt/view"
        elsif version == Versionomy.parse('0.6')
          "http://sourceforge.net/projects/roundcubemail/files/roundcubemail/#{version}/README-#{version}.txt/view"
        else
          "http://sourceforge.net/projects/roundcubemail/files/roundcubemail/#{version}/README_#{version}.txt/view"
        end
      end
    end
  end
end
