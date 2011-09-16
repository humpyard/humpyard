require 'spec_helper'

describe Humpyard::AssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:record)   { Humpyard::Assets::CarrierwaveAsset.new }
  let(:uploader) { Humpyard::AssetUploader.new(record, :file) }
  
  context 'storing files' do
    before do
      
    end
    
    it 'generates directory for uploaders' do
      record.stub(:id) { 42 }
      uploader.store_dir.should == 'humpyard/uploads/42'
    end
    
    it 'generates filename from slug and version' do
      uploader.stub(:to_s) { 'humpyard/uploads/42/image_1234.gif' }
      uploader.filename.should == 'image_1234.gif'
    end
  end
  
  context 'getting meta data' do
    before do
      uploader.store! File.open(File.join(Rails.root, '..', '..', 'spec', 'fixtures', 'humpyard.gif'))
    end

    it 'should save file name to model' do
      record.name.should == 'humpyard.gif'
    end
    
    it 'should save file size to model' do
      record.size.should == 39320
    end
    
    it 'should save content type to model' do
      record.content_type.should == 'image/gif'
    end
  end
end