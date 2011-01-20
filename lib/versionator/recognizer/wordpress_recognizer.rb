
module Versionator
  module Recognizer
    # works with 2.8.*, 2.9.* and 3.*
    class WordpressRecognizer < Base
      def initialize(*args)
        @basic_name = "wordpress"
        @project_url = "http://wordpress.org"
        @name = "WordPress"

        @detect_files = %w{index.php wp-includes/version.php wp-load.php wp-settings.php xmlrpc.php}
        @detect_dirs = %w{wp-admin wp-content wp-includes}

        super(*args)
      end

      def detect_installed_version
        lines = File.readlines(File.join(base_dir, "wp-includes/version.php"))
        version_line = lines.select{ |line| line =~ /^\$wp_version/ }.first

        m = /^\$wp_version = ['"](.+)['"];$/.match(version_line)
        @installed_version = m[1]
      end

      def project_url_for_installed_version
        "#{project_url}/news/wordpress-#{installed_version.gsub('.', '-')}"
      end
    end
  end
end
