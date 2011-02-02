
require 'nokogiri'
require 'open-uri'
require 'versionomy'

module Versionator
  module Detector
    # You may override:
    # * +contents_detected?+
    # * +detect_installed_version+
    # * +detect_newest_version+
    # * +project_url_for_version+
    class Base
      UnknownVersion = Versionomy.parse('0.0')

      attr_reader :base_dir, :installed_version, :newest_version

      def initialize(base_dir = nil)
        @base_dir = base_dir
        @installed_version = UnknownVersion
        @newest_version = UnknownVersion

        if base_dir && detected?
          detect_installed_version
        end
      end

      # Actually looks inside of files to detect a specific application.
      # The default implementation does nothing.
      #
      # This method should be overriden, when applications cannot be safely distinguished by the directory layout alone.
      # This may be the case for multiple supported versions of a single app (e.g. Druapl6 and Drupal7) or if the app was built using a common framework (e.g. Ruby on Rails in Redmine).
      def contents_detected?
        true
      end

      # Tries to detect the newest version by checking online for it.
      # Where and what to look for is determined by the following settings:
      # +newest_version_url+::
      #   The website with the version information.
      #   This URL will be visited and its content scraped.
      # +newest_version_selector+::
      #   A CSS selector for finding the element with the version information on the page.
      #   This can also select multiple elements.
      #   The first one matching the following regexp will be used.
      # +newest_version_regexp+::
      #   Extracts the actual version string out of the selected element.
      #   The first match must be the desired version string.
      #
      # The result will be available as a Versionomy object through the +newest_version+ method.
      #
      # Note: ::    This method can be called without the +base_dir+ set.
      # Warning: :: This method does network access and may therefore take long
      def detect_newest_version
        return @newest_version unless self.class.method_defined?(:newest_version_url)

        doc = Nokogiri::HTML(open(newest_version_url))

        version_selection = doc.css(newest_version_selector)

        version_lines = version_selection.map(&:text)

        version_line = version_lines.find do |line|
          newest_version_regexp.match(line)
        end
        version = newest_version_regexp.match(version_line)[1] if version_line
        @newest_version = Versionomy.parse(version) if version
      end

      # Tries to detect the version of the app installed in +bsae_dir+.
      # Where and what to look for is determined by the following settings:
      # +installed_version_file+::
      #   The file which contains the full version string.
      #   (_version.php_, _ChangeLog_, _PKG-INFO_, etc.)
      # +installed_version_regexp+::
      #   Extracts the actual version string out of the matching line.
      #   The first match must be the desired version string.
      #
      # The result will be available as a Versionomy object through the +newest_version+ method.
      def detect_installed_version
        return @installed_version unless self.class.method_defined?(:installed_version_file)

        version_line = find_first_line(:matching => installed_version_regexp, :in_file => installed_version_file)

        version = extract_version(:from => version_line, :with => installed_version_regexp)
        @installed_version = Versionomy.parse(version) if version
      end

      # Determines whether an app could be detected in +base_dir+.
      #
      # See also: +files_detected?+, +dirs_detected?+, +contents_detected?+
      def detected?
        files_detected? && dirs_detected? && contents_detected?
      end

      # Determines whether the list of directories set through the +detect_dirs+ setting could be found in +base_dir+.
      def dirs_detected?
        dirs_there = self.class.detect_dirs.map { |dir| Dir.exists?(File.expand_path(dir, base_dir)) }
        dirs_there.all?
      end

      # Determines whether the list of files set through the +detect_files+ setting could be found in +base_dir+.
      def files_detected?
        files_there = self.class.detect_files.map { |file| File.exists?(File.expand_path(file, base_dir)) }
        files_there.all?
      end

      # Warning: See warnings for +detect_newest_version+
      # See also: +detect_newest_version+
      def newest_version
        detect_newest_version if @newest_version == UnknownVersion

        @newest_version
      end

      def project_url_for_version(version)
      end

      # This is a convenenience equivalent to:
      #   project_url_for_version(installed_version)
      #
      # See also: +project_url_for_version+
      def project_url_for_installed_version
        project_url_for_version(installed_version)
      end


      # This is a convenenience equivalent to:
      #   project_url_for_version(newest_version)
      #
      # See also: +project_url_for_version+
      def project_url_for_newest_version
        project_url_for_version(newest_version)
      end

      protected

      # Finds the frist line in a file.
      #
      # Options:
      # +:in_file+::        The file (relative to +base_dir+) to search in
      # +:matching+::       Find the first line matching this *regex*
      # +:starting_with+::  Find the line starting with this *string*
      def find_first_line(options)
        return unless options[:in_file]

        lines = File.readlines(File.join(base_dir, options[:in_file]))
        if options[:matching]
          lines.select! { |line| line =~ options[:matching] }
        elsif options[:starting_with]
          lines.select! { |line| line.start_with? options[:starting_with] }
        end
        lines.first
      end

      # This will extract the first match of a regexp from a string.
      #
      # Options:
      # +:from+:: string
      # +:with+:: regexp
      def extract_version(options)
        m = options[:with].match(options[:from])
        m[1]
      end

      # Supported settings:
      # +:basic_name+::
      # +:app_name+::
      # +:project_url+::
      # +:detect_dirs+::
      # +:detect_files+::
      # +:installed_version_file+::
      # +:installed_version_regexp+::
      # +:newest_version_url+::
      # +:newest_version_selector+::
      # +:newest_version_regexp+::
      #
      # Once set, these are available as class and as instance methods.
      def self.set(property, value)
        class_variable_name = "@@#{property.to_s}".to_sym

        # set the value
        class_variable_set(class_variable_name, value)

        # add the class method
        self.class.module_eval do
          define_method property do
            class_variable_get(class_variable_name.to_sym)
          end
        end

        # add a instance method wrapping the class method
        module_eval do
          define_method property do
            self.class.send property
          end
        end
      end
    end
  end
end
