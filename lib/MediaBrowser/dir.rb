require File.dirname(__FILE__) + "/media"

module MediaBrowser
  class Dir
    include FromHash
    attr_accessor :path
    fattr(:media) do
      res = Object::Dir["#{path}/**/*.*"].map { |x| Media.new(:path => x) }.sort
      res.each do |ep|
        ep.has_dir = false if File.dirname(ep.path) == path
      end
      res
    end
    def media_by_season
      media.group_by { |x| [x.show_title,x.season] }.values
    end
    def shows
      media.map { |x| x.show_title }.uniq.sort
    end
    def media_for_show(show)
      media.select { |x| x.show_title == show }
    end
  end
end