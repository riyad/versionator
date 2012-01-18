# encoding: UTF-8

require 'rubygems'
require 'bundler'

Bundler.require

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
