
module Versionator
  module Detector
    # Detects {Tine 2.0}[http://www.tine20.org].
    class Tine20 < Base
      set :app_name, "Tine 2.0"
      set :project_url, "https://www.tine20.org/en/home.html"
      set :project_download_url, "https://www.tine20.org/en/download/download.html"

      set :detect_dirs, %w{Tinebase}
      set :detect_files, %w{tine20.php Tinebase/Core.php}

      set :installed_version_file, "Tinebase/Core.php"
      set :installed_version_regexp, /^\s*define\('TINE20_PACKAGESTRING', '([\.\d-]+)'\);$/

      set :newest_version_url, 'https://www.tine20.org/en/download/download.html'
      set :newest_version_selector, '.downloadArea .tableheader'
      set :newest_version_regexp, /^Stable: \w+ \(([\.\d-]+)\)$/

      def installed_version
        super
      rescue Versionomy::Errors::ParseError
        @installed_version = tine20_versionomy.parse(@installed_version_text)
      end

      def newest_version
        super
      rescue Versionomy::Errors::ParseError
        @newest_version = tine20_versionomy.parse(@newest_version_text)
      end

      private

      # parses Tine 2.0's "xxxx-xx-x" version strings
      def tine20_versionomy
        Versionomy.default_format.modified_copy do
          field(:minor) do
            recognize_number(:default_value_optional => false,
                            :delimiter_regexp => '-',
                            :default_delimiter => '-')
          end
          field(:tiny) do
            recognize_number(:default_value_optional => true,
                            :delimiter_regexp => '-',
                            :default_delimiter => '-')
          end
        end
      end
    end
  end
end
