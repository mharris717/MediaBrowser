module FromHash
  def from_hash(ops)
    ops.each do |k,v|
      send("#{k}=",v)
    end
  end
  def initialize(ops={})
    from_hash(ops)
  end
end

class String
  def without_junk_chars
    gsub(/[ \-_.]/," ")
  end
end

module Enumerable
  def group_by
    res = Hash.new { |h,k| h[k] = [] }
    each { |x| res[yield(x)] << x }
    res
  end
end

module MediaBrowser
  class Media
    include FromHash
    attr_accessor :path
    def season
      return $1.to_i if path =~ /[^a-z0-9]S[ -]?(\d+)/i or path =~ /[^a-z0-9]Season\s?(\d+)/i
      potential_identifying_numbers.each do |str|
        return str[0..-3].to_i
      end
      nil
    end
    def episode_num
      return $1.to_i if path =~ /E(\d+)/i
      potential_identifying_numbers.each do |str|
        return str[-2..-1].to_i
      end
      nil
    end
    def filename
      File.basename(path)
    end
    def potential_identifying_numbers
      filename.scan(/\d{3,4}/)
    end
    def show_title_from_dir
      res = last_dir
      sb = lambda do |*args|
        res = res.gsub(*args)
      end
      
      sb[/([^a-z0-9])(S[ -]?\d+)/i,'\1']
      sb[/([^a-z0-9])(Season\s?\d+)/i,'\1']
      sb[/[ \-_.]/," "]
      res.strip
    end
    def show_title_from_file
      if filename =~ /^(.*)\d{3,4}/
        $1.without_junk_chars.strip
      else
        nil
      end
    end
    def show_title
      if has_dir?
        show_title_from_dir
      else
        show_title_from_file
      end
    end
    def has_dir?
      true
    end
    def last_dir
      File.dirname(path).split("/")[-1]
    end
    def episode_title
      Shows.instance.get(show_title).get_title(self)
    end
    def to_s
      "#{show_title} Season #{season}, Ep #{episode_num} - #{episode_title}"
    end
    def season_to_s
      "#{show_title} Season #{season}"
    end
  end
end