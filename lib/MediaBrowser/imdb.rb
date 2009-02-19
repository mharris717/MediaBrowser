require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'fattr'
require 'singleton'
require File.dirname(__FILE__) + "/store"

class Shows
  include Singleton
  fattr(:hash) do
    Hash.new { |h,k| h[k] = Show.new(:title => k) }
  end
  def get(show)
    hash[show]
  end
end

class Show
  include FromHash
  attr_accessor :title
  store_method(:show_id, :title) do
    show = title.gsub(/ /,"+")
    str = open("http://www.google.com/search?q=#{show}+imdb&btnI=3564") { |f| f.read }
    raise "no" unless str =~ /id=(tt\d+);/
    $1
  end
  fattr(:page) { Page.new(:show_id => show_id) }
  fattr(:episodes) do
    page.episodes
  end
  def get_title(a_ep)
    i_ep = episodes.find { |x| x.season == a_ep.season and x.episode_num == a_ep.episode_num }
    if i_ep
      i_ep.episode_title
    else
      "Unknown"
    end
  end
end

class Ep
  include FromHash
  attr_accessor :season, :episode_num, :episode_title
  def to_s
    "Season #{season} Ep #{episode_num} - #{episode_title}"
  end
end
  
class Page
  include FromHash
  attr_accessor :show_id
  fattr(:doc) do
    Hpricot(open("http://www.imdb.com/title/#{show_id}/episodes"))
  end
  fattr(:seasons) do
    doc.search("//div").select { |x| x.get_attribute('class') =~ /season-filter-all/ }
  end
  fattr(:season_text) { seasons.map { |x| x.innerText }.join("") }
  fattr(:ep_divs) do 
    doc.search("//div").select { |x| x.get_attribute('class') == 'episode_slate_container' }
  end
  store_method(:episodes,:show_id) do
    season_text.scan(/Season (\d+), Episode (\d+): (.*?)Original Air/).map do |arr|
      Ep.new(:season => arr[0].to_i, :episode_num => arr[1].to_i, :episode_title => arr[2].strip)
    end
  end
end
  