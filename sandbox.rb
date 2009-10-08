require File.dirname(__FILE__) + "/lib/MediaBrowser"

if false
puts Time.now
show = Show.new(:title => '30 Rock')
show.episodes.each { |x| x.to_s }
puts Time.now
show = Show.new(:title => '30 Rock')
show.episodes.each { |x| x.to_s }
puts Time.now
end

if false
require 'gtk2'
#require 'ftools' #File tools...

class Tree
  fattr(:store) { Gtk::TreeStore.new(String) }
  fattr(:episodes) do
    Show.new(:title => '30 Rock').episodes
  end
  def insert_seasons!
    episodes.map { |x| x.season }.uniq.sort.each do |s|
      store.insert(nil,999,["Season #{s}"])
    end
  end
  def insert_episodes!
    episodes.each do |ep|
    end
  end
  def load!
    insert_seasons!
    each do |model,path,iter|
      puts iter.inspect
    end
  end
end

Tree.new.load!
end

MediaBrowser::Dir.new(:path => '/Users/mharris/Downloads').media.each { |x| puts x.to_s + " " + x.path }

#m = MediaBrowser::Media.new(:path => "/Videos/30 Rock Season 3/E11.avi")
#m.open_in_hulu!