
module Versionator
  module Recognizer
    class Base
      attr_reader :base_dir, :basic_name, :homepage, :installed_version, :name

      # :rdoc:
      # You may override:
      # - contents_detected?
      # - detect_installed_version
      def initialize(base_dir)
        @base_dir = base_dir

        if detected?
          detect_installed_version
        end
      end

      def contents_detected?
        true
      end

      def detect_installed_version
        "undefined"
      end

      def detected?
        files_detected? && dirs_detected? && contents_detected?
      end

      def dirs_detected?
        dirs_there = @detect_dirs.map { |file| Dir.exists?(File.expand_path(file, base_dir))}
        dirs_there.all?
      end

      def files_detected?
        files_there = @detect_files.map { |file| File.exists?(File.expand_path(file, base_dir))}
        files_there.all?
      end
    end
  end
end
