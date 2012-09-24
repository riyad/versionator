#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

# this will require all the gems not specified to a given group (default)
# and gems specified in the production group
Bundler.require(:default, :production)

# add lib/ to load path
libdir = File.dirname(__FILE__) + '/lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'versionator/application'

Versionator::Application.run!
