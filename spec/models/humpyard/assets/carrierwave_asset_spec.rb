require 'spec_helper'

describe Humpyard::Assets::CarrierwaveAsset do
  context 'database configuration' do
    it 'should have valid table name' do
      Humpyard::Assets::CarrierwaveAsset.table_name.should == 'humpyard_assets_carrierwave_assets'
    end
  end
  
  context 'url' do
    it 'should get url from content data' do
      subject.file.should_receive(:url).with(nil) { '/humpyard/assets/42/test.jpg' }

      subject.url.should == '/humpyard/assets/42/test.jpg'
    end
    
    it 'should get url for specific version' do
      subject.file.should_receive(:url).with(:thumb) { '/humpyard/assets/42/test_thumb.jpg' }

      subject.url(:thumb).should == '/humpyard/assets/42/test_thumb.jpg'
    end
    
    it 'should get original url for specified version "original"' do
      subject.file.should_receive(:url).with(nil) { '/humpyard/assets/42/test.jpg' }

      subject.url('original').should == '/humpyard/assets/42/test.jpg'
    end
  end
  
  context 'versions' do
    before do
      subject.width = 640
      subject.height = 240
    end
    
    it 'should get original version if no versions were configured' do
      Humpyard::config.asset_carrierwave_image_versions = {}
      subject.versions.should == {:original=>[640, 240]}
    end
    
    it 'should get scale to fit version configured' do
      Humpyard::config.asset_carrierwave_image_versions = {icon: [:fit, 64, 80], large: [:fit, 1280, 1080], narrow: [:fit, 320, 25]}
      subject.versions.should == {original: [640, 240], icon: [64, 24], large: [1280, 480], narrow: [67, 25]}
    end

    it 'should get scale to fill version configured' do
      Humpyard::config.asset_carrierwave_image_versions = {icon: [:fill, 64, 80], large: [:fill, 1280, 1080], narrow: [:fill, 320, 24]}
      subject.versions.should == {original: [640, 240], icon: [64, 80], large: [1280, 1080], narrow: [320, 24]}
    end

    it 'should get scale to limit version configured' do
      Humpyard::config.asset_carrierwave_image_versions = {icon: [:limit, 64, 80], large: [:limit, 1280, 1080], narrow: [:limit, 320, 25]}
      subject.versions.should == {original: [640, 240], icon: [64, 24], narrow: [67, 25]}
    end
    
    it 'should get scale to limit version configured (including dups)' do
      Humpyard::config.asset_carrierwave_image_versions = {icon: [:limit, 64, 80], large: [:limit, 1280, 1080], narrow: [:limit, 320, 25]}
      subject.versions(include_duplicates: true).should == {original: [640, 240], icon: [64, 24], large: [640, 240], narrow: [67, 25]}
    end
    
  end
end