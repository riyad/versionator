
module Versionator
  module Detector
    # Detects {Redmine}[http://www.redmine.org]
    class Redmine14 < Base
      set :app_name, "Redmine 1.4"
      set :project_url, "http://www.redmine.org"

      set :detect_dirs, %w{app config lib public vendor}
      set :detect_files, %w{doc/CHANGELOG Rakefile README.rdoc}

      set :installed_version_file, "doc/CHANGELOG"
      set :installed_version_regexp, /^== \d\d\d\d-\d\d-\d\d v(.+)$/

      set :newest_version_url, 'http://www.redmine.org/projects/redmine/wiki/Download'
      set :newest_version_selector, '#content .wiki li'
      set :newest_version_regexp, /^(1\..*) \([\d-]+\)$/

      def contents_detected?
        # Overridden to make sure we detect Redmine and not any RoR app.
        if super && find_first_line(:matching => /^= Redmine/, :in_file => "README.rdoc")
          installed_version.major == 1
        end
      end

      def project_url_for_version(version)
        if version >= Versionomy.parse('1.1')
          "#{project_url}/projects/redmine/wiki/Changelog"
        else
          "#{project_url}/projects/redmine/wiki/Changelog_#{version.major}_#{version.minor}"
        end
      end
    end
  end
end
