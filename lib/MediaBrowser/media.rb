require 'rubygems'
require 'imdb_tv'
require File.dirname(__FILE__) + "/ext"

module MediaBrowser
  class Media
    include FromHash
    attr_accessor :path
    def season_regexes
      [/([^a-z0-9])(S[ -]?)(\d+)/i,/([^a-z0-9])(Season\s?)(\d+)/i]
    end
    def season
      season_regexes.each do |reg|
        return $3.to_i if path =~ reg
      end
      potential_identifying_number ? potential_identifying_number[0..-3].to_i : nil
    end
    def episode_num
      return $1.to_i if path =~ /E(\d+)/i
      potential_identifying_number ? potential_identifying_number[-2..-1].to_i : nil
    end
    def filename
      File.basename(path)
    end
    def potential_identifying_number
      filename.scan(/\d{3,4}/).first
    end
    def show_title_from_dir
      res = season_regexes.inject(last_dir) { |res,reg| res.gsub(reg,'\1') }
      res.without_junk_chars.strip
    end
    def show_title_from_file
      (filename =~ /^(.*)\d{3,4}/) ? $1.without_junk_chars.strip : nil
    end
    def show_title
      has_dir? ? show_title_from_dir : show_title_from_file
    end
    def has_dir?
      true
    end
    def last_dir
      File.dirname(path).split("/")[-1]
    end
    def episode_title
      ImdbTV::Shows.instance.get(show_title).get_title(self)
    end
    def to_s
      "#{show_title} Season #{season}, Ep #{episode_num} - #{episode_title}"
    end
    def season_to_s
      "#{show_title} Season #{season}"
    end
  end
end