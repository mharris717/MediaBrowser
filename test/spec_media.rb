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

def should_have_show_title_inner(path,show)
  it "#{path} should be show #{show}" do
    MB::Media.new(:path => path).show_title.should == show
  end
end

def should_have_show_title_no_dir_inner(path,show)
  it "#{path} should be show #{show}" do
    media = MB::Media.new(:path => path)
    media.stub!('has_dir?' => false)
    media.show_title.should == show
  end
end

def should_have_show_title(*args)
  should_have_show_title_inner(*args)
  #should_have_show_title_no_dir_inner(*args)
end

def should_have_show_title_no_dir(*args)
  #should_have_show_title_inner(*args)
  should_have_show_title_no_dir_inner(*args)
end

def should_parse(*args)
end

describe "Media" do
  before do
    @media = MediaBrowser::Media.new(:path => "/Videos/Breaking Bad - Season 1/E1.avi")
  end
  it 'smoke' do
    2.should == 2
  end
  it 'filename' do
    @media.filename.should == 'E1.avi'
  end
  it 'last_dir' do
    @media.last_dir.should == 'Breaking Bad - Season 1'
  end
  should_have_season "/Videos/Breaking Bad - Season 1/E1.avi",1
  should_have_season "/Videos/S2/E3.avi",2
  should_have_season "/Videos/Season 2/E4.avi",2
  should_have_season "/Videos/SEASON 2/E4/avi",2
  should_have_season "Its.Always.Sunny.S02E01E02",2
  should_have_season "MS14_S2E3.avi",2
  should_have_season "/Videos/Season2/E4.avi",2
  should_have_season "/Videos/Wall-E.avi",nil
  should_have_season "mad.men.201.hdtv-lol",2
  should_have_season "mad.men.2x01.hdtv-lol",2
  should_have_season "/Videos/Mad Men S-2/E4.avi",2
  should_have_season "Breaking.Bad.S01E01.HDTV.XviD-BiA.avi",1
  should_have_season "Breaking.Bad.S1E1.HDTV.XviD-BiA.avi",1
  should_have_season "Breaking.Bad.S1 E1.HDTV.XviD-BiA.avi",1
  should_have_season "simpsons.1408.hdtv-lol",14
  
  should_have_episode_num "/Videos/S2/E3.avi",3
  should_have_episode_num "mad.men.201.hdtv-lol",1
  should_have_episode_num "mad.men.2x03.thth",3
  should_have_episode_num "mad.men.2x01.hdtv-lol",1
  should_have_episode_num "mad.men.2x1.hdtv-lol",1
  should_have_episode_num "/Videos/Mad Men S-2/E4.avi",4
  should_have_episode_num "Breaking.Bad.S01E01.HDTV.XviD-BiA.avi",1
  should_have_episode_num "Breaking.Bad.S1E1.HDTV.XviD-BiA.avi",1
  should_have_episode_num "Breaking.Bad.S1 E1.HDTV.XviD-BiA.avi",1
  should_have_episode_num "simpsons.1408.hdtv-lol",8
  should_have_episode_num 'Sealab 2021.311.HDTV.XviD-LOL.avi',11
  
  should_have_show_title "/Videos/Breaking Bad - Season 1/E4.avi",'Breaking Bad'
  should_have_show_title "/Videos/Mad Men S-2/E4.avi",'Mad Men'
  should_have_show_title '/Videos/Top.Chef.S03/E3.avi','Top Chef'
  should_have_show_title '/Videos/The Wire Season 2/E5.avi','The Wire'
  should_have_show_title '30.Rock.S03E11.HDTV.XviD-LOL.avi','30 Rock'
  should_have_show_title '30.Rock.311.HDTV.XviD-LOL.avi','30 Rock'
  should_have_show_title 'Sealab 2021.311.HDTV.XviD-LOL.avi','Sealab 2021'
  
  should_have_show_title_no_dir '/Videos/Breaking Bad.705.hdtv-lol','Breaking Bad'
  should_have_show_title_no_dir '/Videos/24.705.hdtv-lol','24'
  should_have_show_title_no_dir '/Videos/Breaking.Bad.705.hdtv-lol','Breaking Bad'
  should_have_show_title_no_dir '/Videos/Breaking.Bad705.hdtv-lol','Breaking Bad'
  
  should_have_show_title '/Volumes/Drobo/TV/Scrubs/Scrubs.S2.DVDRip_XviD-FoV/scrubs.2x01.my_overkill.dvdrip_xvid-fov.avi','Scrubs'
  should_have_show_title '/Volumes/Drobo/TV/Extras/Extras - Season 1 - Complete/Extras - 1x01 - Ben Stiller.avi','Extras'
  should_have_show_title '/Volumes/Drobo/TV/Deadwood/Deadwood - Season 3/tpz-deadwood305.avi','Deadwood'
  #should_have_show_title "/Volumes/Drobo/TV/Human Giant/Human Giant - Extras/Human Giant - Hosting - Aziz Ansari with Vampire Weekend at Bonnaroo, the Summer Of Music, 2008, Xbox Live.avi"
  
  should_parse "/Videos/Breaking Bad - Season 1/E1.avi",'Breaking Bad',1,1
  should_parse "/Videos/S2/E3.avi",nil,2,3
  should_parse "/Videos/Season 2/E4.avi",2
  should_parse "/Videos/SEASON 2/E4/avi",2
  should_parse "Its.Always.Sunny.S02E01E02",2
  should_parse "MS14_S2E3.avi",2
  should_parse "/Videos/Season2/E4.avi",2
  should_parse "/Videos/Wall-E.avi",nil
  should_parse "mad.men.201.hdtv-lol",2
  should_parse "mad.men.2x01.hdtv-lol",2
  should_parse "/Videos/Mad Men S-2/E4.avi",2
  should_parse "Breaking.Bad.S01E01.HDTV.XviD-BiA.avi",1
  should_parse "Breaking.Bad.S1E1.HDTV.XviD-BiA.avi",1
  should_parse "Breaking.Bad.S1 E1.HDTV.XviD-BiA.avi",1
  should_parse "simpsons.1408.hdtv-lol",14
  
  # describe 'imdb' do
  #    it 'pilot title' do
  #      @ep = MB::Media.new
  #      @ep.stub!(:season => 1, :episode_num => 1, :show_title => 'Mad Men')
  #      ImdbTV::Shows.instance.get("Mad Men").should_receive(:get_title).with(@ep).and_return('Smoke Gets in Your Eyes')
  #      @ep.episode_title.should == 'Smoke Gets in Your Eyes'
  #    end
  #  end
end

