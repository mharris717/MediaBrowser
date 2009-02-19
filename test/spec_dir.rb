require File.dirname(__FILE__) + "/spec_helper"
MB = MediaBrowser
require 'facets/file/write'

describe MB::Dir do
  def create_video(path)
    file = "#{@root}/#{path}"
    mkdir_recursive(File.dirname(file))
    File.create(file,"")
    @video_paths << path
  end
  def create_series(name,seasons,episodes)
    (1..seasons).each do |s|
      (1..episodes).each do |ep|
        create_video "#{name} Season #{s}/E#{ep}.avi"
      end
    end
  end
  before do
    @root = "/tmp/temp_videos_dir"
    @video_paths = []
    @dir = MB::Dir.new(:path => @root)
    mkdir_if(@root)
    create_series '30 Rock',2,22
    create_series 'Mad Men',2,13
    create_series '24',4,24
    create_video "24.501.hdtv.avi"
  end
  it 'smoke' do
    2.should == 2
  end
  it 'media' do
    @dir.media.size.should == @video_paths.size
  end
  it 'media_by_season' do
    @dir.media_by_season.size.should == 9
  end
  it 'correct sort' do
    nums = @dir.media_by_season.first.map { |x| x.episode_num }
    nums.should == nums.sort
   # @dir.media.each { |x| puts x.path }
  end
  it '24 should have 97 eps' do
    @dir.media_for_show('24').size.should == 97
  end
  after do
    FileUtils.rm_r(@root)
  end
end