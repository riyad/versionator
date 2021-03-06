
module Versionator
  module Detector
    # Detects {Drupal 8}[http://drupal.org].
    class Drupal8 < Base
      set :app_name, "Drupal 8"
      set :project_url, "https://drupal.org"
      set :project_download_url, "https://drupal.org/project/drupal"

      set :detect_dirs, %w{core modules profiles sites themes}
      set :detect_files, %w{autoload.php composer.json core/CHANGELOG.txt index.php robots.txt}

      set :installed_version_file, "core/CHANGELOG.txt"
      set :installed_version_regexp, /^Drupal ([\d\.]+)[,\s].*$/

      set :newest_version_url, 'https://drupal.org/project/drupal'
      set :newest_version_selector, '.view-project-release-download-table .views-field-field-release-version a'
      set :newest_version_regexp, /^(8.+)$/

      # Overridden to make sure that we do only detect Drupal7
      def contents_detected?
        installed_version.major >= 8 if super
      end
    end
  end
end
