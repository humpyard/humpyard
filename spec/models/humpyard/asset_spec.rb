require 'spec_helper'

describe Humpyard::Asset do
  context 'database configuration' do
    it 'should have valid table name' do
      Humpyard::Asset.table_name.should == 'humpyard_assets'
    end
  end
  
  context 'title' do
    it 'should get title from content data if not set' do
      content_data = mock('AssetContentData', title: 'My Title')
      subject.stub(:content_data) { content_data }
      
      subject.title.should == 'My Title'
    end
    
    it 'should get not title from content data if set' do
      subject.title = 'My own Title'
      content_data = mock('AssetContentData', title: 'My Title')
      subject.stub(:content_data) { content_data }
      
      subject.title.should == 'My own Title'
    end
    
    it 'should return nil if not set and content data has no title' do
      content_data = mock('AssetContentData')
      subject.stub(:content_data) { content_data }
      
      subject.title.should be_nil
    end
    
    
  end
  
  context 'url' do
    it 'should get url from content data' do
      content_data = mock('AssetContentData', url: '/humpyard/assets/42/test.jpg')
      subject.stub(:content_data) { content_data }

      subject.url.should == '/humpyard/assets/42/test.jpg'
    end
    
    it 'should get url for specific version from content data' do
      content_data = mock('AssetContentData')
      content_data.should_receive(:url).with(:thumb) { '/humpyard/assets/42/test_thumb.jpg' }
      subject.stub(:content_data) { content_data }

      subject.url(:thumb).should == '/humpyard/assets/42/test_thumb.jpg'
    end
  end
  
  context 'content_type' do
    it 'should get content_type from content data' do
      content_data = mock('AssetContentData', content_type: 'application/test')
      subject.stub(:content_data) { content_data }

      subject.content_type.should == 'application/test'
    end
  end
  
  context 'versions' do
    it 'should get only original version if content data does not have a versions function' do
      content_data = mock('AssetContentData')
      subject.stub(:content_data) { content_data }
      subject.width = 320
      subject.height = 200

      subject.versions.should == {original: [320, 200]}
    end
    
    it 'should get only original version if content data does have a versions function returning nil' do
      content_data = mock('AssetContentData', versions: nil)
      subject.stub(:content_data) { content_data }
      subject.width = 320
      subject.height = 200

      subject.versions.should == {original: [320, 200]}
    end
    
    it 'should get versions from content data if returning one' do
      content_data = mock('AssetContentData', versions: {special: [2000, 10], thumb: [32, 32]})
      subject.stub(:content_data) { content_data }
      subject.width = 320
      subject.height = 200

      subject.versions.should == {special: [2000, 10], thumb: [32, 32]}
    end
  end
end
