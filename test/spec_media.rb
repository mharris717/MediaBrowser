require File.dirname(__FILE__) + "/spec_helper"

MB = MediaBrowser

def should_have_season(path,season)
  it "#{path} should be season #{season}" do
    MB::Media.new(:path => path).season.should == season
  end
end    

def should_have_episode_num(path,ep)
  it "#{path} should be episode number #{ep}" do
    MB::Media.new(:path => path).episode_num.should == ep
  end
end

def should_have_show_title(path,show)
  it "#{path} should be show #{show}" do
    MB::Media.new(:path => path).show_title.should == show
  end
end

def should_have_show_title_no_dir(path,show)
  it "#{path} should be show #{show}" do
    media = MB::Media.new(:path => path)
    media.stub!('has_dir?' => false)
    media.show_title.should == show
  end
end


describe "Media" do
  before do
    @media = MediaBrowser::Media.new(:path => "/Videos/Breaking Bad - Season 1/E1.avi")
  end
  it 'smoke' do
    2.should == 2
  end
  it 'season' do
    @media.season.should == 1
  end
  it 'filename' do
    @media.filename.should == 'E1.avi'
  end
  it 'scan' do
    str = "abcdfdfd1234fgdfgjldfgljj567dugfhgfgjfgso99999"
    str.scan(/\d{3,5}/).should == %w(1234 567 99999)
  end
  it 'last_dir' do
    @media.last_dir.should == 'Breaking Bad - Season 1'
  end
  it 'gsub' do
    "abcdefgh".gsub(/b(cd)/,"x").should == "axefgh"
    #"abcdefgh".gsub(/b(cd)/,'\`x').should == "abxefgh"
    "abcdefgh".gsub(/(\w)(cd)/,'\1x').should == "abxefgh"
    "abc.def".gsub(/[.d]/,"").should == "abcef"
    "abc.def-ghi".gsub(/[.\-d]/,"").should == "abcefghi"
  end
  should_have_season "/Videos/S2/E3.avi",2
  should_have_season "/Videos/Season 2/E4.avi",2
  should_have_season "/Videos/SEASON 2/E4/avi",2
  should_have_season "Its.Always.Sunny.S02E01E02",2
  should_have_season "MS14_S2E3.avi",2
  should_have_season "/Videos/Season2/E4.avi",2
  should_have_season "/Videos/Wall-E.avi",nil
  should_have_season "mad.men.201.hdtv-lol",2
  should_have_season "/Videos/Mad Men S-2/E4.avi",2
  should_have_season "Breaking.Bad.S01E01.HDTV.XviD-BiA.avi",1
  should_have_season "simpsons.1408.hdtv-lol",14
  
  should_have_episode_num "/Videos/S2/E3.avi",3
  should_have_episode_num "mad.men.201.hdtv-lol",1
  
  should_have_show_title "/Videos/Breaking Bad - Season 1/E4.avi",'Breaking Bad'
  should_have_show_title "/Videos/Mad Men S-2/E4.avi",'Mad Men'
  should_have_show_title '/Videos/Top.Chef.S03/E3.avi','Top Chef'
  should_have_show_title '/Videos/The Wire Season 2/E5.avi','The Wire'
  
  should_have_show_title_no_dir '/Videos/Breaking Bad.705.hdtv-lol','Breaking Bad'
  should_have_show_title_no_dir '/Videos/24.705.hdtv-lol','24'
  should_have_show_title_no_dir '/Videos/Breaking.Bad.705.hdtv-lol','Breaking Bad'
  should_have_show_title_no_dir '/Videos/Breaking.Bad705.hdtv-lol','Breaking Bad'
end

if false
describe 'imdb page' do
  before(:all) do
    @show = Shows.instance.get('Mad Men')
    @page = @show.page
    @show.stub!(:show_id => "abc")
    @page.stub!(:doc => Hpricot(open(File.dirname(__FILE__) + "/madmen.html")))
  end
  it 'episode count' do
    @page.episodes.size.should == 26
  end
  it 'pilot title' do
    @ep = MB::Media.new
    @ep.stub!(:season => 1, :episode_num => 1, :show_title => 'Mad Men')
    @ep.episode_title.should == 'Smoke Gets in Your Eyes'
  end
end
end