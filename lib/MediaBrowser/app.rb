#Shoes.setup do
#  gem 'activesupport'
#end

Shoes.setup do
  gem 'fattr'
  gem 'hpricot'
  gem 'activerecord'
  gem 'GFunk911-imdb-tv'
  gem 'facets'
end

require File.dirname(__FILE__) + "/../MediaBrowser"

class Foo
  fattr(:bar) { 'abc' }
  fattr(:cat) do
    Hpricot(open("http://cnn.com")).innerText.length.to_s
  end
end

if false
Shoes.app :width => 300, :height => 400 do
  stack :margin => 10 do
    button(Foo.new.bar) do
      puts "HI"
    end
    button(Foo.new.cat) do
      puts "FOO"
    end
  end
end
end

class Object
  def local_methods
    res = methods - 7.methods - "".methods
    #res.sort_by { |x| x.to_s }
    res
  end
end

class MediaApp < Shoes
  url '/', :index
  fattr(:dir) { MediaBrowser::Dir.new(:path => '/tmp/temp_videos_dir') }
  def display_show(show,season)
    @ep_stack.clear
    eps = dir.media.select { |x| x.show_title == show and x.season == season }
    @ep_stack.append do
      para show
      eps.each do |ep|
        para(link(ep.to_s) { ep.play! })
      end
    end
  end
  def update_season_dropdown(show)
    seasons = dir.media.select { |x| x.show_title == show }.map { |x| x.season }.uniq.sort
    @seasons.items = seasons.map { |x| "Season #{x}"}
  end
  def index
    stack do
      @shows = list_box(:items => dir.shows) do |*args|
        update_season_dropdown(args.first.text)
      end
      @seasons = list_box(:items => []) do |box|
        season = box.text.split(/ /)[-1].to_i
        display_show(@shows.text,season)
      end
    end
    @ep_stack = stack
  end
end

Shoes.app

if false
class MHolder
  def episodes
    Dir["/Users/mharris/TV/**/*.*"].map { |x| MediaBrowser::Media.new(:path => x) }
  end
  def episodes_by_season
    episodes.group_by { |x| [x.show_title,x.season] }.values
  end
end

Shoes.app :width => 300, :height => 400 do
  @it = MHolder.new
  stack :margin => 10 do
    @it.episodes_by_season.each do |eps|
      para(eps.first.season_to_s)
      eps.each do |ep|
        para(link(ep.to_s) { alert 'Hello' })
      end
    end
  end
end
end