
require 'nokogiri'
require 'open-uri'
require 'versionomy'

module Versionator
  module Detector
    class Base
      UnknownVersion = Versionomy.parse('0.0')

      attr_reader :base_dir, :installed_version, :newest_version

      # You may override:
      # - contents_detected?
      # - detect_installed_version
      # - detect_newest_version
      # - project_url_for_version
      def initialize(base_dir = nil)
        @base_dir = base_dir
        @installed_version = UnknownVersion
        @newest_version = UnknownVersion

        if detected?
          detect_installed_version
        end
      end

      def contents_detected?
        true
      end

      # does network access, may therefore take long
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

      def detect_installed_version
        return @installed_version unless self.class.method_defined?(:installed_version_file)

        version_line = find_first_line(:matching => installed_version_regexp, :in_file => installed_version_file)

        version = extract_version(:from => version_line, :with => installed_version_regexp)
        @installed_version = Versionomy.parse(version) if version
      end

      def detected?
        files_detected? && dirs_detected? && contents_detected?
      end

      def dirs_detected?
        dirs_there = self.class.detect_dirs.map { |dir| Dir.exists?(File.expand_path(dir, base_dir)) }
        dirs_there.all?
      end

      def files_detected?
        files_there = self.class.detect_files.map { |file| File.exists?(File.expand_path(file, base_dir)) }
        files_there.all?
      end

      def installed_version_detected?
        installed_version != UnknownVersion
      end

      # see: detect_newest_version
      def newest_version
        detect_newest_version if @newest_version == UnknownVersion

        @newest_version
      end

      def project_url_for_version(version)
      end

      def project_url_for_installed_version
        project_url_for_version(installed_version)
      end

      def project_url_for_newest_version
        project_url_for_version(newest_version)
      end

      protected

      # finds the frist line in a file
      # options:
      # :in_file        the file (relative to base_dir) to search in
      # :matching       find the first line matching this regex
      # :starting_with  find the line starting with this string
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

      # this will extract the first match of a regexp from a string
      # options:
      # :from  string
      # :with  regexp
      def extract_version(options)
        m = options[:with].match(options[:from])
        m[1]
      end

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
