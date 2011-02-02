#!/usr/bin/env rake

require 'rdoc/task'

desc "Generate documentation"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Versionator Documentation"

  rdoc.options << '-f' << 'horo'
  rdoc.options << '-c' << 'utf-8'
  rdoc.options << '-m' << 'README.rdoc'

  rdoc.rdoc_files.include('README.rdoc')

  rdoc.rdoc_files.include('versionator.rb')

  rdoc.rdoc_files.include('lib/**/*.rb')
end
