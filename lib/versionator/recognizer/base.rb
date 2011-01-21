
module Versionator
  module Recognizer
    class Base
      attr_reader :base_dir, :installed_version

      # :rdoc:
      # You may override:
      # - contents_detected?
      # - detect_installed_version
      # - project_url_for_installed_version
      def initialize(base_dir = nil)
        @base_dir = base_dir

        if detected?
          detect_installed_version
        end
      end

      def contents_detected?
        true
      end

      def detect_installed_version
        @installed_version = "unknown version"
      end

      def detected?
        files_detected? && dirs_detected? && contents_detected?
      end

      def dirs_detected?
        dirs_there = self.class.detect_dirs.map { |dir| Dir.exists?(File.expand_path(dir, base_dir))}
        dirs_there.all?
      end

      def files_detected?
        files_there = self.class.detect_files.map { |file| File.exists?(File.expand_path(file, base_dir))}
        files_there.all?
      end

      def project_url_for_installed_version
      end

      protected

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
