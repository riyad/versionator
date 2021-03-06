# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'

# this will require all the gems not specified to a given group (default)
# and gems specified in the production group
Bundler.require(:default, :production)

# set the encoding for files being read
Encoding.default_external = 'UTF-8'

# log to this file
log = File.new('log/sinatra.log', 'a')
$stdout.reopen(log)
$stderr.reopen(log)

# add lib/ to load path
libdir = File.dirname(__FILE__) + '/lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'versionator/application'

run Versionator::Application
