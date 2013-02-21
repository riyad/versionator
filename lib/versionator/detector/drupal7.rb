
module Versionator
  module Detector
    # Detects {Drupal 7}[http://drupal.org].
    class Drupal7 < Base
      set :app_name, "Drupal 7"
      set :project_url, "http://drupal.org"
      set :project_download_url, "http://drupal.org/project/drupal"

      set :detect_dirs, %w{includes misc modules profiles scripts sites themes}
      set :detect_files, %w{CHANGELOG.txt cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, "CHANGELOG.txt"
      set :installed_version_regexp, /^Drupal ([\d\.]+)[,\s].*$/

      set :newest_version_url, 'http://drupal.org/project/drupal'
      set :newest_version_selector, '.download-table .project-release .views-row-first .views-field-version a'
      set :newest_version_regexp, /^(7.+)$/

      # Overridden to make sure that we do only detect Drupal7
      def contents_detected?
        installed_version.major >= 7 if super
      end
    end
  end
end
