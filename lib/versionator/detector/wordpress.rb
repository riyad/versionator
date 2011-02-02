
module Versionator
  module Detector
    # Detects {WordPress}[http://wordpress.org].
    # This will detect versions 2.8.*, 2.9.* and 3.*.
    class Wordpress < Base
      set :app_name, "WordPress"
      set :project_url, "http://wordpress.org"

      set :detect_dirs, %w{wp-admin wp-content wp-includes}
      set :detect_files, %w{index.php wp-includes/version.php wp-load.php wp-settings.php xmlrpc.php}

      set :installed_version_file, "wp-includes/version.php"
      set :installed_version_regexp, /^\$wp_version = ['"](.+)['"];$/

      set :newest_version_url, 'http://wordpress.org/download'
      set :newest_version_selector, '.download-meta .download-button'
      set :newest_version_regexp, /^Download.WordPress.(.+)$/

      def project_url_for_version(version)
        "#{project_url}/news/wordpress-#{version.to_s.gsub('.', '-')}"
      end
    end
  end
end
