Dir[File.dirname(__FILE__) + "/MediaBrowser/*.rb"].reject { |x| x =~ /app/ }.each { |x| require x }