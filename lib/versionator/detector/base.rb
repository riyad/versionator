
require 'nokogiri'
require 'open-uri'
require 'versionomy'

module Versionator
  module Detector
    # This is the base class for all application detectors.
    #
    # Add a derived class for each application you want to have detected.
    # Specify the according settings using the ::set method.
    #
    # In special cases you may override the following methods:
    # * #contents_detected?
    # * #detect_installed_version
    # * #detect_newest_version
    class Base
      # Specifies an unknown version.
      # This is eqivalent to version "0.0".
      UnknownVersion = Versionomy.parse('0.0')

      attr_reader :base_dir, :installed_version, :newest_version

      # Creates a new detector.
      # You will only be able to use installation specific features if you specifiy the _base_dir_ param.
      # For detecting the newest version you will not need to set the _base_dir_ param.
      def initialize(base_dir = nil)
        @base_dir = base_dir
        @installed_version = UnknownVersion
        @newest_version = UnknownVersion
      end

      def self.basic_name
        File.basename(self.name.underscore)
      end
      def basic_name
        self.class.basic_name
      end

      # Actually looks inside of files to detect a specific application.
      # The default implementation always returns +true+.
      #
      # This method should be overriden, when applications cannot be safely distinguished by the directory layout alone.
      # This may be the case for multiple supported versions of a single app (e.g. Druapl6 and Drupal7) or if the app was built using a common framework (e.g. Ruby on Rails in Redmine).
      def contents_detected?
        true
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
      # The result will be available as a Versionomy object through #installed_version .
      # As a fallback the unparsed version string will be avaialble through #@installed_version_text .
      def detect_installed_version
        return @installed_version unless self.class.method_defined?(:installed_version_file)

        version_match = find_first_match(:matching => installed_version_regexp, :in_file => installed_version_file)

        # if multiple parts are matched, join them back
        version = version_match.captures.reject(&:nil?).join(".")

        # convert commas into dots so Versionomy can parse them too
        version = version.gsub(',', '.')

        if version
          @installed_version_text = version.strip
          @installed_version = Versionomy.parse(@installed_version_text).change({}, :optional_fields => [:tiny])
        end
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
      #   The first capture must be the desired version string.
      #
      # The result will be available as a Versionomy object through #newest_version .
      # As a fallback the unparsed version string will be avaialble through #@newest_version_text .
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
        if version
          @newest_version_text = version.strip
          @newest_version = Versionomy.parse(@newest_version_text).change({}, :optional_fields => [:tiny])
        end
      end

      # Determines whether an app could be detected in +base_dir+.
      #
      # See also: #files_detected? , #dirs_detected? , #contents_detected?
      def detected?
        files_detected? && dirs_detected? && contents_detected?
      end

      # Determines whether the list of directories set through the +detect_dirs+ setting could be found in #base_dir .
      def dirs_detected?
        dirs_there = detect_dirs.map { |dir| Dir.exists?(File.expand_path(dir, base_dir)) }
        dirs_there.all?
      end

      # Determines whether the list of files set through the +detect_files+ setting could be found in #base_dir .
      def files_detected?
        files_there = detect_files.map { |file| File.exists?(File.expand_path(file, base_dir)) }
        files_there.all?
      end

      # See also: #detect_installed_version
      def installed_version
        detect_installed_version if @installed_version == UnknownVersion

        @installed_version
      end

      # Warning: See warnings for #detect_newest_version
      # See also: #detect_newest_version
      def newest_version
        detect_newest_version if @newest_version == UnknownVersion

        @newest_version
      end

      protected

      # Finds the frist match in a file.
      #
      # Options:
      # +:in_file+::        The file (relative to +base_dir+) to search in
      # +:matching+::       Find the first match of this *regex*
      # +:starting_with+::  Find the first line starting with this *string*
      def find_first_match(options)
        return unless options[:in_file]

        open(File.join(base_dir, options[:in_file])) do |file|
          regexp = options[:matching] || Regexp.new("^#{options[:starting_with]}")
          regexp.match(file.read)
        end
      end

      # Supported settings:
      # +:app_name+::     Tha application's name (e.g. "Drupal 7").
      # +:project_url+::  The project's website.
      # +:detect_dirs+::  See: #dirs_detected?
      # +:detect_files+:: See: #files_detected?
      # +:installed_version_file+::   See: #detect_installed_version
      # +:installed_version_regexp+:: See: #detect_installed_version
      # +:newest_version_url+::       See: #detect_newest_version
      # +:newest_version_selector+::  See: #detect_newest_version
      # +:newest_version_regexp+::    See: #detect_newest_version
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
