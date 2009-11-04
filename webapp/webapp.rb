require 'rubygems'
require File.dirname(__FILE__) + "/../lib/MediaBrowser"

require 'sinatra'

$dir ||= MediaBrowser::Dir.new(:path => '/Volumes/Drobo/Torrents/Completed')

get '/' do
  @dir = $dir
  haml(:index)
end

get '/play/:id' do
  media = $dir.media.select { |x| x.media_id.to_s == params[:id].to_s }.first
  puts "playing #{media.to_s}"
  media.play!
end


