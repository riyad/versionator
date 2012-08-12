
module Versionator
  module Detector
    # Detects {MediaWiki}[http://www.mediawiki.org].
    class Mediawiki < Base
      set :app_name, "MediaWiki"
      set :project_url, "http://www.mediawiki.org"

      set :detect_dirs, %w{bin extensions images includes maintenance skins}
      set :detect_files, %w{api.php includes/DefaultSettings.php index.php redirect.php thumb.php}

      set :installed_version_file, "includes/DefaultSettings.php" # see contents_detected?
      set :installed_version_regexp, /^\$wgVersion\s*= '(.+)';$/

      set :newest_version_url, 'http://www.mediawiki.org/wiki/Download'
      set :newest_version_selector, '#bodyContent .plainlinks a'
      set :newest_version_regexp, /^Download MediaWiki (.+)$/

      def project_url_for_version(version)
        if version < Versionomy.parse('1.18')
          "http://svn.wikimedia.org/svnroot/mediawiki/tags/REL#{version.change({}, :optional_fields => []).to_s.gsub('.', '_')}/phase3/RELEASE-NOTES"
        else
          "http://svn.wikimedia.org/svnroot/mediawiki/tags/REL#{version.change({}, :optional_fields => []).to_s.gsub('.', '_')}/phase3/RELEASE-NOTES-#{version.to_s}"
        end
      end
    end
  end
end
