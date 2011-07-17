
module Versionator
  module Detector
    # Detects {Collabtive}[http://collabtive.o-dyn.de].
    class Collabtive < Base
      set :app_name, "Collabtive"
      set :project_url, "http://collabtive.o-dyn.de/"

      set :detect_dirs, %w{config files include templates}
      set :detect_files, %w{admin.php changelog.txt index.php init.php install.php license.txt manageajax.php myprojects.php mytasks.php}

      set :installed_version_file, "changelog.txt"
      set :installed_version_regexp, /^Collabtive (.+)$/

      set :newest_version_url, 'http://collabtive.o-dyn.de/'
      set :newest_version_selector, 'div.content_right div.content_right_in_right p'
      set :newest_version_regexp, /^\s*Current Release: (.+)\s*.*$/
    end
  end
end