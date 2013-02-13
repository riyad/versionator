
module Versionator
  module Detector
    # Detects {Redmine}[http://www.redmine.org]
    class Redmine < Base
      set :app_name, "Redmine"
      set :project_url, "http://www.redmine.org"

      set :detect_dirs, %w{app config lib public vendor}
      set :detect_files, %w{doc/CHANGELOG Rakefile README.rdoc}

      set :installed_version_file, "doc/CHANGELOG"
      set :installed_version_regexp, /^== \d\d\d\d-\d\d-\d\d v(.+)$/

      set :newest_version_url, 'http://www.redmine.org/projects/redmine/wiki/Download'
      set :newest_version_selector, '#content .wiki li'
      set :newest_version_regexp, /^(.+) \([\d-]+\)$/

      def contents_detected?
        # Overridden to make sure we detect Redmine and not any RoR app.
        super && find_first_line(:matching => /^= Redmine/, :in_file => "README.rdoc")
      end
    end
  end
end
