#!/usr/bin/env ruby

# add lib/ to load path
libdir = File.dirname(__FILE__) + '/lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'versionator/application'

Versionator::Application.run!
