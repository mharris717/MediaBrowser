require File.dirname(__FILE__) + "/media"

module MediaBrowser
  class Dir
    include FromHash
    attr_accessor :path
    fattr(:unsorted_media) do
      res = Object::Dir["#{path}/**/*.avi"]
      res = res.map { |x| Media.new(:path => x) }
      res.each do |ep|
        ep.has_dir = false if File.dirname(ep.path) == path
      end
      res
    end
    fattr(:media) do
      unsorted_media.select { |x| x.full_desc? }.sort
    end
    fattr(:unclassified_media) do
      unsorted_media.reject { |x| x.full_desc? }
    end
    def media_by_season
      media.group_by { |x| [x.show_title,x.season] }.values
    end
    def shows
      media.map { |x| x.show_title }.uniq.sort
    end
    fattr(:series) do
      media.group_by { |x| x.show_title }.map { |k,x| Series.new(:name => k, :media => x) }
    end
    def children
      series
    end
    def to_s
      'Dir'
    end
    def each(&b)
      children.each(&b)
    end
    def media_for_show(show)
      media.select { |x| x.show_title == show }
    end
    class << self
      fattr(:test_dir) do
        new(:path => "/tmp/temp_videos_dir")
      end
      def mock_dir
        require 'ostruct'
        media = ['30 Rock','Mad Men','House'].map do |show|
          [1,2,3].map do |season|
            (1..13).map do |ep|
              stat = OpenStruct.new(:size => 99, :ctime => Time.now)
              OpenStruct.new(:show_title => show, :episode_num => ep, :season => season, :stat => stat, :name => "#{show} Season #{season} Ep #{ep}")
            end
          end
        end.flatten
        new(:media => media)
      end
    end
  end
end