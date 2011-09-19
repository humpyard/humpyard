require 'spec_helper'

describe Humpyard::Assets::YoutubeAsset do
  context 'database configuration' do
    it 'should have valid table name' do
      Humpyard::Assets::YoutubeAsset.table_name.should == 'humpyard_assets_youtube_assets'
    end
  end
  
  context 'title' do
    it 'should get YouTube title if set' do
      subject.youtube_video_id = 'a1234567890'
      subject.youtube_title = 'A great YouTube Video'
      
      subject.title.should == 'A great YouTube Video'
    end
    
    it 'should get generic title if no one set' do
      subject.youtube_video_id = 'a1234567890'
      
      subject.title.should == 'YouTube a1234567890'
    end
  end
  
  context 'url' do
    it 'should get url from content data' do
      subject.youtube_video_id = 'a1234567890'

      subject.url.should == 'http://www.youtube.com/watch?v=a1234567890'
    end
    
    it 'should ignore versions' do
      subject.youtube_video_id = 'a1234567890'

      subject.url(:thumb).should == 'http://www.youtube.com/watch?v=a1234567890'
    end
    
  end
  
  context 'content_type' do
    it 'should always get video content type' do
      subject.content_type.should == 'video/youtube'
    end
  end
  
  context 'update_youtube_data' do
    before do
      response = mock('NetHTTPResponse')
      response.stub(:body) {
        "<?xml version='1.0' encoding='UTF-8'?>"+
        "<entry xmlns='http://www.w3.org/2005/Atom' xmlns:media='http://search.yahoo.com/mrss/' + xmlns:gd='http://schemas.google.com/g/2005' xmlns:yt='http://gdata.youtube.com/schemas/2007'>" +
          "<id>http://gdata.youtube.com/feeds/api/videos/a1234567890</id>"+
          "<published>2011-02-01T04:53:28.000Z</published>"+
          "<updated>2011-03-13T01:57:19.000Z</updated>"+
          "<category scheme='http://schemas.google.com/g/2005#kind' term='http://gdata.youtube.com/schemas/2007#video'/>"+
          "<category scheme='http://gdata.youtube.com/schemas/2007/categories.cat' term='Entertainment' label='Entertainment'/>"+
          "<category scheme='http://gdata.youtube.com/schemas/2007/keywords.cat' term='Test'/>"+
          "<category scheme='http://gdata.youtube.com/schemas/2007/keywords.cat' term='RSpec'/>"+
          "<title type='text'>A great YouTube Video</title>"+
          "<content type='text'>This is a demo video for testing Humpyard Assets</content>"+
          "<link rel='alternate' type='text/html' href='http://www.youtube.com/watch?v=a1234567890&amp;feature=youtube_gdata'/>"+
          "<link rel='http://gdata.youtube.com/schemas/2007#video.related' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos/a1234567890/related'/>" +
          "<link rel='http://gdata.youtube.com/schemas/2007#mobile' type='text/html' href='http://m.youtube.com/details?v=a1234567890'/>"+
          "<link rel='self' type='application/atom+xml' href='http://gdata.youtube.com/feeds/api/videos/a1234567890'/>"+
          "<author>"+
            "<name>Humpyard</name>"+
            "<uri>http://gdata.youtube.com/feeds/api/users/humpyard</uri>"+
          "</author>"+
          "<media:group>"+
            "<media:category label='Entertainment' scheme='http://gdata.youtube.com/schemas/2007/categories.cat'>Entertainment</media:category>"+
            "<media:content url='http://www.youtube.com/v/a1234567890?f=videos&amp;app=youtube_gdata' type='application/x-shockwave-flash' medium='video' isDefault='true' expression='full' duration='31' yt:format='5'/>"+
            "<media:content url='rtsp://v5.cache5.c.youtube.com/CiILENy73wIaGQlQk_koD7WY_xMYDSANFExxxa1234567890/0/0/0/video.3gp' type='video/3gpp' medium='video' expression='full' duration='31' yt:format='1'/>"+
            "<media:content url='rtsp://v3.cache2.c.youtube.com/CiILENy73wIaGQlQk_koD7WY_xMYESARFExxxa1234567890/0/0/0/video.3gp' type='video/3gpp' medium='video' expression='full' duration='31' yt:format='6'/>"+
            "<media:description type='plain'>This is a demo video for testing Humpyard Assets</media:description>"+
            "<media:keywords>Test, RSpec</media:keywords>"+
            "<media:player url='http://www.youtube.com/watch?v=a1234567890&amp;feature=youtube_gdata_player'/>"+
            "<media:thumbnail url='http://i.ytimg.com/vi/a1234567890/0.jpg' height='360' width='480' time='00:00:15.500'/>"+
            "<media:thumbnail url='http://i.ytimg.com/vi/a1234567890/1.jpg' height='90' width='120' time='00:00:07.750'/>"+
            "<media:thumbnail url='http://i.ytimg.com/vi/a1234567890/2.jpg' height='90' width='120' time='00:00:15.500'/>"+
            "<media:thumbnail url='http://i.ytimg.com/vi/a1234567890/3.jpg' height='90' width='120' time='00:00:23.250'/>"+
            "<media:title type='plain'>A great YouTube Video</media:title>"+
            "<yt:duration seconds='31'/>"+
          "</media:group>"+
          "<gd:rating average='4.478261' max='5' min='1' numRaters='2346' rel='http://schemas.google.com/g/2005#overall'/>"+
          "<yt:statistics favoriteCount='416' viewCount='391299'/>"+
        "</entry>"
      }
      require 'net/http'
      
      Net::HTTP.stub(:get_response) {response}
    end
    
    it 'should get title' do
      subject.youtube_video_id = 'a1234567890'
      subject.update_youtube_data
      subject.title.should == 'A great YouTube Video'
    end
    it 'should get (fake) dimensions' do
      subject.youtube_video_id = 'a1234567890'
      subject.update_youtube_data
      subject.width.should == 480
      subject.height.should == 360
    end
  end
end
