
module Versionator
  module Detector
    # Detects {Drupal 7}[http://drupal.org].
    class Drupal7 < Base
      set :app_name, "Drupal 7"
      set :project_url, "https://drupal.org"
      set :project_download_url, "https://drupal.org/project/drupal"

      set :detect_dirs, %w{includes misc modules profiles scripts sites themes}
      set :detect_files, %w{CHANGELOG.txt cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, "CHANGELOG.txt"
      set :installed_version_regexp, /^Drupal ([\d\.]+)[,\s].*$/

      set :newest_version_url, 'https://drupal.org/project/drupal'
      set :newest_version_selector, '.view-project-release-download-table .views-field-field-release-version a'
      set :newest_version_regexp, /^(7.+)$/

      # Overridden to make sure that we do only detect Drupal7
      def contents_detected?
        !is_openatrium? && installed_version.major >= 7 if super
      end

      def is_openatrium?
        Dir.exists?(File.expand_path("profiles/openatrium", base_dir))
      end
    end
  end
end
