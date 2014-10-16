
module Versionator
  module Detector
    # Detects {Open Atrium}[http://openatrium.com/].
    class OpenAtrium < Base
      set :app_name, "Open Atrium"
      set :project_url, "http://openatrium.com"
      set :project_download_url, "https://drupal.org/project/openatrium"

      set :detect_dirs, %w{includes misc modules profiles profiles/openatrium scripts sites themes}
      set :detect_files, %w{cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, nil # placeholder
      set :installed_version_regexp, nil # placeholder

      set :newest_version_url, 'https://drupal.org/project/openatrium'
      set :newest_version_selector, '.view-project-release-download-table .views-field-field-release-version a'
      set :newest_version_regexp, /^7\.x-(.+)$/

      # Overridden to take into account different files for different versions
      def detected?
        super && installed_version_file
      end

      protected

      # Overridden to take into account different files for different versions
      def installed_version_file
        %w{
            profiles/openatrium/modules/contrib/oa_core/oa_core.info
            profiles/openatrium/VERSION.txt
        }.find{ |version_file| File.readable?(File.join(base_dir, version_file)) }
      end

      # Overridden to take into account different files for different versions
      def installed_version_regexp
        if installed_version_file.end_with? ".info"
          /^version = "\d.x-(.+)"$/
        else
          /^(.+)$/
        end
      end
    end
  end
end
