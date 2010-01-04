require 'rubygems'
#require File.dirname(__FILE__) + "/../../../imdb-tv/lib/imdb_tv"
require File.dirname(__FILE__) + "/ext"
require 'andand'

def ec(cmd)
  puts cmd
  res = `#{cmd}`
  puts res
  res
end

require 'facets/file/write'
def dbg(str)
  File.append(File.dirname(__FILE__) + "/debug.log",Time.now.to_s + " " + str+"\n")
end

class Object
  def if_blank
    blank? ? yield : self
  end
end

module MediaBrowser
  class Media
    include FromHash
    attr_accessor :path, :stat
    def season_regexes
      [/([^a-z0-9])(S[ -]?)(\d+)/i,/([^a-z0-9])(Season\s?)(\d+)/i,/()()(\d+)x(\d+)/]
    end
    def show_regexes
      [/^(.{3,99})S\d/,/^(.*)\d{3,4}/]
    end
    def regex_match(regexes,str,&b)
      regexes.each do |reg|
        if str =~ reg
          return b.call(nil,$1,$2,$3,$4,$5)
        end
      end
      nil
    end
    def season
      regex_match(season_regexes,path) { |*m| return m[3].to_i }
      potential_identifying_number ? potential_identifying_number[0..-3].to_i : nil
    end
    def episode_num
      return $1.to_i if path =~ /E(\d+)/i
      return $1.to_i if path =~ /\dx(\d+)/i
      potential_identifying_number ? potential_identifying_number[-2..-1].to_i : nil
    end
    def filename
      File.basename(path)
    end
    def potential_identifying_number
      filename.scan(/\d{3,4}/).last
    end
    def show_title_from_dir
      res = season_regexes.inject(last_dir) { |res,reg| res.split(reg).first }
      res = res.without_junk_chars.strip
      #res = res.split(/(dvdrip|xvid|hdtv|720p)/i).first.without_junk_chars.strip
    end
    def show_title_from_file
      res = regex_match(show_regexes,filename) { |*m| m[1] }
      if res =~ /-/ && res =~ /#{show_title_from_dir}/i
        res = show_title_from_dir
      end
      res = res.andand.without_junk_chars.andand.strip
      res
    end
    fattr(:show_title) do
      if false
        show_title_from_dir.if_blank { show_title_from_file }
      else
        show_title_from_file.if_blank { show_title_from_dir }
      end
    end
    def full_desc?
      sort_arr.all? { |x| x }
    end
    def has_dir?
      has_dir
    end
    def tv_show?
      (120000000..400000000).include?(FileTest.size(path))
    end
    fattr(:has_dir) { true }
    def last_dir
      File.dirname(path).split("/")[-1]
    end
    def episode_title
      return "foo"
      ImdbTV::Shows.instance.get(show_title).get_title(self)
    end
    def to_s
      "#{show_title} Season #{season}, Ep #{episode_num} - #{episode_title}"
    end
    def season_to_s
      "#{show_title} Season #{season}"
    end
    def sort_arr
      [show_title,season,episode_num]
    end
    def <=>(ep)
      sort_arr <=> ep.sort_arr
    end
    def save!
      require File.dirname(__FILE__) + "/media_db"
      MediaRow.save_media(self)
    end
    def play!
      puts `/Applications/VLC.app/Contents/MacOS/VLC "#{path}"`
    end
    def hulu_url
      ImdbTV.google_fl_url("#{show_title} #{episode_title} hulu")
    end
    def open_in_hulu!
      ec "/usr/bin/open \"#{hulu_url}\""
    end
    def clean_filename
      "#{show_title} - S#{season}E#{episode_num}"
    end
    def mkdir_if_compound(dir)
      eat_exceptions { FileUtils.mkdir_p(dir) }
    end
    fattr(:media_id) { rand(100000000000000) }
    def make_link!(root_link_dir)
      mkdir_if_compound File.join(root_link_dir,show_title,"Season #{season}")
      filename = File.join(root_link_dir,show_title,"Season #{season}",clean_filename)
      ec "mklink /H \"#{filename}\" \"#{path}\""
    end
  end
end

def eat_exceptions
  yield
rescue => exp
end