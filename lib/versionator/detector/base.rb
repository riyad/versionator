
module Versionator
  module Detector
    class Base
      UnknownVersion = "unknown version"

      attr_reader :base_dir, :installed_version

      # :rdoc:
      # You may override:
      # - contents_detected?
      # - detect_installed_version
      # - project_url_for_installed_version
      def initialize(base_dir = nil)
        @base_dir = base_dir
        @installed_version = UnknownVersion

        if detected?
          detect_installed_version
        end
      end

      def contents_detected?
        true
      end

      def detect_installed_version
        return @installed_version unless self.class.method_defined?(:installed_version_file)

        version_line = find_first_line(:matching => installed_version_regexp, :in_file => File.join(base_dir, installed_version_file))

        @installed_version = extract_version(:from => version_line, :with => installed_version_regexp)
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

      def project_url_for_installed_version
      end

      protected

      # finds the frist line in a file
      # options:
      # :in_file        the file to search in
      # :matching       find the first line matching this regex
      # :starting_with  find the line starting with this string
      def find_first_line(options)
        return unless options[:in_file]

        lines = File.readlines(File.join(base_dir, installed_version_file))
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
