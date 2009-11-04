#Dir[File.dirname(__FILE__) + "/MediaBrowser/*.rb"].reject { |x| x =~ /app/ }.each { |x| require x }
require 'rubygems'
require 'activesupport'
require 'fattr'
%w(ext media dir series season).each { |x| require File.dirname(__FILE__) + "/MediaBrowser/#{x}" }