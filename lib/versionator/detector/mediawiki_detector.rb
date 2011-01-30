
module Versionator
  module Detector
    class MediawikiDetector < Base
      set :basic_name, "mediawiki"
      set :app_name, "MediaWiki"
      set :project_url, "http://www.mediawiki.org"

      set :detect_dirs, %w{bin config extensions images includes maintenance skins}
      set :detect_files, %w{api.php index.php redirect.php RELEASE-NOTES thumb.php}

      set :installed_version_file, "RELEASE-NOTES"
      set :installed_version_regexp, /^== MediaWiki (.+) ==$/

      set :newest_version_url, 'http://www.mediawiki.org/wiki/Download'
      set :newest_version_selector, '#bodyContent .plainlinks a'
      set :newest_version_regexp, /^Download MediaWiki (.+)$/

      def contents_detected?
        true if find_first_line(:matching => installed_version_regexp, :in_file => File.join(base_dir, installed_version_file))
      end

      def project_url_for_version(version)
        "http://svn.wikimedia.org/svnroot/mediawiki/tags/REL#{version.to_s.gsub('.', '_')}/phase3/RELEASE-NOTES"
      end
    end
  end
end
