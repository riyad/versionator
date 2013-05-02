
module Versionator
  module Detector
    # Detects {Drupal 6}[http://drupal.org].
    # This will also detect installed Drupal versions prior to the 6 series.
    # But it will only check for the most recent version of the 6 series.
    class Drupal6 < Base
      set :app_name, "Drupal 6"
      set :project_url, "http://drupal.org"
      set :project_download_url, "http://drupal.org/project/drupal"

      set :detect_dirs, %w{includes misc modules profiles scripts sites themes}
      set :detect_files, %w{CHANGELOG.txt cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, "CHANGELOG.txt"
      set :installed_version_regexp, /^Drupal (.+), .*$/

      set :newest_version_url, 'http://drupal.org/project/drupal'
      set :newest_version_selector, '.download-table .project-release .release-update-status-0 .views-field-version a'
      set :newest_version_regexp, /^(6.+)$/

      # Overridden to make sure that we do not also detect Drupal7 or Open Atrium
      def contents_detected?
        !is_openatrium? && installed_version.major < 7 if super
      end

      def is_openatrium?
        Dir.exists?(File.expand_path("profiles/openatrium", base_dir))
      end
    end
  end
end
