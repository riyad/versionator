
module Versionator
  module Detector
    # Detects {Drupal 6}[http://drupal.org].
    # This will also detect Drupal 5.
    class Drupal6 < Base
      set :app_name, "Drupal 6"
      set :project_url, "http://drupal.org"

      set :detect_dirs, %w{includes misc modules profiles scripts sites themes}
      set :detect_files, %w{cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, "CHANGELOG.txt"
      set :installed_version_regexp, /^Drupal (.+), .*$/

      set :newest_version_url, 'http://drupal.org/project/drupal'
      set :newest_version_selector, '.download-table .project-release .release-update-status-0 .views-field-version a'
      set :newest_version_regexp, /^(6.+)$/

      # Overridden to make sure that we do not also detect Drupal7
      def detected?
        installed_version.major < 7 if super
      end

      def project_url_for_version(version)
        "#{project_url}/drupal-#{version}"
      end
    end
  end
end
