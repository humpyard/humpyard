require 'spec_helper'

describe Humpyard::UriParser do
  context 'parsers' do
    it 'should get array of subclasses' do
      Humpyard::UriParser.parsers.should == [Humpyard::UriParser::PagesUriParser, Humpyard::UriParser::AssetsUriParser]
    end
  end
  
  context 'substitute' do
    it 'should leave http links untouched' do
      result = Humpyard::UriParser.substitute '<a href="http://humpyard.org/">Humpyard</a>'
      result.should == '<a href="http://humpyard.org/">Humpyard</a>'
    end
    
    it 'should replace humpyard page links' do
      page = mock_model Humpyard::Page
      Humpyard::Page.stub(:find, 42) { page }
      page.stub(:human_url) { '/some_great_page.html' }
      
      result = Humpyard::UriParser.substitute '<a href="humpyard://page/42">Test</a>'
      result.should == '<a href="/some_great_page.html">Test</a>'
    end
    
  end
end