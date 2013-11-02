
module Versionator
  module Detector
    # Detects {Open Atrium}[http://openatrium.com/].
    class OpenAtrium < Base
      set :app_name, "Open Atrium"
      set :project_url, "http://openatrium.com"
      set :project_download_url, "http://openatrium.com/download"

      set :detect_dirs, %w{includes misc modules profiles profiles/openatrium scripts sites themes}
      set :detect_files, %w{cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, "foo" # placeholder
      set :installed_version_regexp, /^(foo)$/ # placeholder

      set :newest_version_url, 'https://drupal.org/project/openatrium'
      set :newest_version_selector, '.view-project-release-download-table .views-field-field-release-version a'
      set :newest_version_regexp, /^7\.x-(.+)$/

      # Overridden to take into account different files for different versions
      def detected?
        super && (
          File.readable?(File.join(base_dir, "profiles/openatrium/openatrium.info")) ||
          File.readable?(File.join(base_dir, "profiles/openatrium/VERSION.txt"))
        )
      end

      def version_2x?
        File.readable?(File.join(base_dir, "profiles/openatrium/openatrium.info"))
      end

      protected

      # Overridden to take into account different files for different versions
      def installed_version_file
        if version_2x?
          "profiles/openatrium/openatrium.info"
        else
          "profiles/openatrium/VERSION.txt"
        end
      end

      # Overridden to take into account different files for different versions
      def installed_version_regexp
        if version_2x?
          /^version = "7.x-(.+)"$/
        else
          /^(.+)$/
        end
      end
    end
  end
end
