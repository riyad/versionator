
module Versionator
  module Detector
    # Detects {Open Atrium}[http://openatrium.com/].
    class OpenAtrium < Base
      set :app_name, "Open Atrium"
      set :project_url, "http://openatrium.com"

      set :detect_dirs, %w{includes misc modules profiles profiles/openatrium scripts sites themes}
      set :detect_files, %w{cron.php index.php install.php profiles/openatrium/VERSION.txt xmlrpc.php}

      set :installed_version_file, "profiles/openatrium/VERSION.txt"
      set :installed_version_regexp, /^(.+)$/

      set :newest_version_url, 'http://openatrium.com/download'
      set :newest_version_selector, '#block-views-openatrium_releases-block_1 .field-content'
      set :newest_version_regexp, /^Download (.+)$/

      def project_url_for_version(version)
         # target specific releases
        if version == Versionomy.parse("1.0")
          "#{project_url}/node/44"
        else
          "#{project_url}/download"
        end
      end
    end
  end
end
