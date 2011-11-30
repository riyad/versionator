
module Versionator
  module Detector
    # Detects {MediaWiki}[http://www.mediawiki.org].
    class Mediawiki < Base
      set :app_name, "MediaWiki"
      set :project_url, "http://www.mediawiki.org"

      set :detect_dirs, %w{bin extensions images includes maintenance skins}
      set :detect_files, %w{api.php index.php redirect.php thumb.php}

      set :installed_version_file, "RELEASE-NOTES" # see contents_detected?
      set :installed_version_regexp, /^== MediaWiki (.+) ==$/

      set :newest_version_url, 'http://www.mediawiki.org/wiki/Download'
      set :newest_version_selector, '#bodyContent .plainlinks a'
      set :newest_version_regexp, /^Download MediaWiki (.+)$/

      # Overriden to detect RELEASE-NOTES-x.yy files form 1.18 onwards
      def contents_detected?
        # look for RELEASE-NOTES or RELEASE-NOTES-x.yy files and sort them,
        # because we want the latest one in case there are multiple
        release_notes = Dir.glob(File.expand_path("RELEASE-NOTES*", base_dir)).sort
        # the paths have been expanded, make them relative again
        @@installed_version_file = release_notes.last[File.expand_path(base_dir).size..-1]

        !release_notes.empty?
      end

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
