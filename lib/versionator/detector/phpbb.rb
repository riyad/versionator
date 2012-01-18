
module Versionator
  module Detector
    # Detects {phpBB}[http://www.phpbb.com].
    class Phpbb < Base
      set :app_name, "phpBB"
      set :project_url, "http://www.phpbb.com"

      set :detect_dirs, %w{adm download files includes install store styles}
      set :detect_files, %w{common.php cron.php faq.php index.php install/schemas/schema_data.sql posting.php search.php viewforum.php viewonline.php viewtopic.php}

      set :installed_version_file, "install/schemas/schema_data.sql"
      set :installed_version_regexp, /^INSERT INTO .+ VALUES \('version', '(.+)'\);$/

      set :newest_version_url, 'http://www.phpbb.com/downloads/'
      set :newest_version_selector, '#extras .download a'
      set :newest_version_regexp, /^Version: phpBB (.+)/

      def project_url_for_version(version)
        "http://www.phpbb.com/support/documentation/#{version.major}.#{version.minor}/"
      end
    end
  end
end
