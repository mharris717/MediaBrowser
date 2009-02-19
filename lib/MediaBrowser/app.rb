#Shoes.setup do
#  gem 'activesupport'
#end

Shoes.setup do
  gem 'fattr'
  gem 'hpricot'
  gem 'activerecord'
end

require File.dirname(__FILE__) + "/media"
require File.dirname(__FILE__) + "/imdb"

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

if true
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