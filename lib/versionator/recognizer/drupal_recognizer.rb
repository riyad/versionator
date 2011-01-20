
module Versionator
  module Recognizer
    # works with Drupal 6 and 7
    class DrupalRecognizer < Base

      def initialize(*args)
        @basic_name = "drupal"
        @project_url = "http://drupal.org"
        @name = "Drupal"

        @detect_files = %w{cron.php index.php install.php xmlrpc.php}
        @detect_dirs = %w{includes misc modules profiles scripts sites themes}

        super(*args)
      end

      def contents_detected?
        version_from_changelog.start_with? "Drupal"
      end

      def detect_installed_version
        m = /^Drupal (.+), .*$/.match version_from_changelog
        @installed_version = m[1]
      end

      def project_url_for_installed_version
        "#{project_url}/drupal-#{installed_version}"
      end

      private

      def version_from_changelog
        changelog = File.readlines(File.join(base_dir, "CHANGELOG.txt"))
        changelog.select! { |line| line =~ /^Drupal/ }
        changelog.first
      end
    end
  end
end
