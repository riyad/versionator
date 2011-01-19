
module Versionator
  module Recognizer
    class Drupal6Recognizer < Base

      def initialize(*args)
        @homepage = 'http://drupal.org/'
        @name = "Drupal6"

        @detect_files = %w{cron.php index.php install.php xmlrpc.php}
        @detect_dirs = %w{includes misc modules profiles scripts sites themes}

        super(*args)
      end

      def detect_installed_version
      end
    end
  end
end
