
module Versionator
  module Detector
    class Drupal7Detector < Base
      set :basic_name, "drupal7"
      set :app_name, "Drupal 7"
      set :project_url, "http://drupal.org"

      set :detect_dirs, %w{includes misc modules profiles scripts sites themes}
      set :detect_files, %w{cron.php index.php install.php xmlrpc.php}

      set :installed_version_file, "CHANGELOG.txt"
      set :installed_version_regexp, /^Drupal (7.+), .*$/

      set :newest_version_url, 'http://drupal.org/project/drupal'
      set :newest_version_selector, '.download-table .project-release .views-row-first .views-field-version a'
      set :newest_version_regexp, /^(7.+)$/

      def contents_detected?
        true if find_first_line(:matching => installed_version_regexp, :in_file => File.join(base_dir, installed_version_file))
      end

      def project_url_for_installed_version
        "#{project_url}/drupal-#{installed_version}"
      end

      def project_url_for_newest_version
        "#{project_url}/drupal-#{newest_version}"
      end
    end
  end
end
