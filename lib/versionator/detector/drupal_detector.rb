
module Versionator
  module Detector
    # works with Drupal 6 and 7
    class DrupalDetector < Base
      set :basic_name, "drupal"
      set :app_name, "Drupal"
      set :project_url, "http://drupal.org"

      set :detect_dirs, %w{includes misc modules profiles scripts sites themes}
      set :detect_files, %w{cron.php index.php install.php xmlrpc.php}

      set :version_file, "CHANGELOG.txt"
      set :version_regexp, /^Drupal (.+), .*$/

      def contents_detected?
        true if find_first_line(:matching => version_regexp, :in_file => File.join(base_dir, version_file))
      end

      def project_url_for_installed_version
        "#{project_url}/drupal-#{installed_version}"
      end
    end
  end
end
