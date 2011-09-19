require 'spec_helper'

describe Humpyard::AssetsController do    
  context 'index' do
    let(:assets) { [mock_model(Humpyard::Asset)] }
  
    before do
      Humpyard::Asset.stub(:all) { assets }
    end
    
    it 'should check for authorization' do
      get :index
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:manage, Humpyard::Asset) {}
      get :index
      response.status.should == 200
    end
    
    it 'should assign asset content data' do
      controller.stub(:authorize!).with(:manage, Humpyard::Asset) {}
      get :index
      assigns[:assets].should == assets
    end
    
    it 'should render template' do
      controller.stub(:authorize!).with(:manage, Humpyard::Asset) {}
      get :index
      response.should render_template(:index)
    end   
  end
  
  context 'new' do
    let(:new_asset) { mock_model(Humpyard::Asset, asset: 'asset_data') }
    
    before do
      Humpyard::config.stub(:asset_types) { {'some_asset_type' => mock('AssetClass', new: new_asset) } }
    end
    
    it 'should check for authorization' do
      get :new, type: 'some_asset_type'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if asset type exists' do
      get :new, type: 'some_nonexisiting_type'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:create, 'asset_data') { true }
      get :new, type: 'some_asset_type'
      response.status.should == 200
    end
    
    it 'should assign assets' do
      controller.stub(:authorize!).with(:create, 'asset_data') { true }
      get :new, type: 'some_asset_type'
      assigns[:asset].should == new_asset
      assigns[:next_asset].should be_nil
      assigns[:prev_asset].should be_nil
    end
    
    it 'should render template' do
      controller.stub(:authorize!).with(:create, 'asset_data') { true }
      get :new, type: 'some_asset_type'
      response.should render_template(:edit)
    end  
  end
  
  context :create do
    let(:asset_data) {mock('SomeAssetData', id: 42, to_param: '42')}
    let(:new_asset) { mock_model(Humpyard::Asset, asset: asset_data, container: mock('ContainerAsset', id: 23)) }
    
    before do
      Humpyard::config.stub(:asset_types) { {'some_asset_type' => mock('AssetClass', new: new_asset) } }
    end
    
    it 'should check for authorization' do
      post :create, type: 'some_asset_type'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if asset type exists' do
      get :new, type: 'some_nonexisiting_type'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:create, asset_data) {  }
      new_asset.stub(:save) { false }
      post :create, type: 'some_asset_type'
      response.status.should == 200
    end
    
    it 'should assign assets' do
      controller.stub(:authorize!).with(:create, asset_data) {  }
      new_asset.stub(:save) { true }
      post :create, type: 'some_asset_type'
      assigns[:asset].should == new_asset
      assigns[:next_asset].should be_nil
      assigns[:prev_asset].should be_nil
    end
    
    it 'should render template for error case' do
      controller.stub(:authorize!).with(:create, asset_data) {  }
      new_asset.stub(:errors) { {some_field: 'some_value'} }
      new_asset.stub(:save) { false }
      post :create, type: 'some_asset_type'
      response.body.should == '{"status":"failed","errors":{"some_field":"some_value"},"flash":{"level":"error","content":"Failed to create Asset!"}}' 
    end  
    
    it 'should render template for save case' do
      controller.stub(:authorize!).with(:create, asset_data) {  }
      new_asset.stub(:save) { true }
      post :create, type: 'some_asset_type'
      response.body.should == '{"status":"ok","replace":[{"element":"hy-asset-listview","content":""}],"flash":{"level":"info","content":"Successfully created Asset."}}' 
    end  
  end
  
  context :edit do
    let(:content_data) { mock('SomeAssetData', asset: 'asset_data') }
    let(:asset) { mock_model(Humpyard::Asset, content_data: content_data) }
   
    before do
      Humpyard::Asset.stub(:find).with('some_asset') { asset }
      Humpyard::Asset.stub(:find).with('some_nonexisiting_asset') { raise ActiveRecord::RecordNotFound }
    end
    
    it 'should check for authorization' do
      get :edit, id: 'some_asset'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if asset exists' do
      get :edit, id: 'some_nonexisiting_asset'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, asset) {}
      get :edit, id: 'some_asset'
      response.status.should == 200
    end
    
    it 'should assign assets' do
      controller.stub(:authorize!).with(:update, asset) { }
      get :edit, id: 'some_asset'
      assigns[:asset].should == content_data
    end
        
    it 'should render template' do
      controller.stub(:authorize!).with(:update, asset) {  }
      get :edit, id: 'some_asset'
      response.should render_template(:edit)
    end
  end  
  
  context :update do
    let(:content_data) { mock('SomeAssetData', errors: {}, id: 42, title: 'Some Title') }
    let(:asset) { mock_model(Humpyard::Asset, content_data: content_data, suggested_title_for_url: '/some/title', id: 45) }
    
    before do
      Humpyard::Asset.stub(:find).with('some_asset') { asset }
      Humpyard::Asset.stub(:find).with('some_nonexisiting_asset') { raise ActiveRecord::RecordNotFound }
      content_data.stub(:title_for_url=).with('/some/title')
      asset.stub(:content_data) { content_data }
    end
    
    it 'should check for authorization' do
      put :update, id: 'some_asset'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if asset exists' do
      put :update, id: 'some_nonexisiting_asset'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, asset) { }
      content_data.stub(:update_attributes) { false }
      put :update, id: 'some_asset'
      response.status.should == 200
    end
    
    it 'should assign asset' do
      controller.stub(:authorize!).with(:update, asset) { }
      content_data.stub(:update_attributes) { false }
      put :update, id: 'some_asset'
      assigns[:asset].should == asset
    end
    
    it 'should render template for error case' do
      controller.stub(:authorize!).with(:update, asset) { }
      content_data.stub(:errors) { {some_field: 'some_value'} }
      content_data.stub(:update_attributes) { false }
      
      put :update, id: 'some_asset'
      response.body.should == '{"status":"failed","errors":{"some_field":"some_value"},"flash":{"level":"error","content":"Failed to update Asset!"}}' 
    end  
    
    it 'should render template for save case' do
      controller.stub(:authorize!).with(:update, asset) { }
      content_data.stub(:update_attributes) { true }
      content_data.stub(:title_for_url=).with('/some/title') {}
      content_data.stub(:save) { true }
      put :update, id: 'some_asset'
      response.body.should == '{"status":"ok","replace":[{"element":"hy-asset-listview-text-45","content":""}],"flash":{"level":"info","content":"Successfully updated Asset."}}' 
    end
  end
  
  context :destroy do
    let(:asset) { mock_model(Humpyard::Asset, asset: 'asset_data') }
    
    before do
      Humpyard::Asset.stub(:find).with('some_asset') { asset }
      Humpyard::Asset.stub(:find).with('some_nonexisiting_asset') {  raise ActiveRecord::RecordNotFound  }
    end
    
    it 'should check for authorization' do
      delete :destroy, id: 'some_asset'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if asset exists' do
      delete :destroy, id: 'some_nonexisiting_asset'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:destroy, asset) { }
      delete :destroy, id: 'some_asset'
      response.status.should == 200
      response.body.should == '{"status":"ok"}'
    end
    
    it 'should assign asset' do
      controller.stub(:authorize!).with(:destroy, asset) { }
      delete :destroy, id: 'some_asset'
      assigns[:asset].should == asset
    end
    
    it 'should delete asset' do
      controller.stub(:authorize!).with(:destroy, asset) { }
      asset.should_receive(:destroy)
      delete :destroy, id: 'some_asset'
      response.status.should == 200
    end
  end
  
  context :show do
    let(:asset) { mock_model(Humpyard::Asset, content_data: 'asset_content') }
    
    before do
      Humpyard::Asset.stub(:find).with('some_nonexisiting_asset') { raise ActiveRecord::RecordNotFound }
      Humpyard::Asset.stub(:find).with('some_asset') {asset}
    end
    
    it 'should get an 404 error on non existing assets' do
      get :show, id: 'some_nonexisiting_asset'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check for authorization' do
      get :show, id: 'some_asset'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should show the asset' do
      controller.stub(:authorize!).with(:show, asset) {}
      get :show, id: 'some_asset'
      response.status.should == 200
      assigns[:asset].should == 'asset_content'
      response.should render_template(:show)
    end
  end
  
  context :versions do
    let(:asset) { mock_model(Humpyard::Asset, content_data: 'asset_content') }
    
    before do
      Humpyard::Asset.stub(:find).with('some_nonexisiting_asset') { raise ActiveRecord::RecordNotFound }
      Humpyard::Asset.stub(:find).with('some_asset') {asset}
    end
    
    it 'should get an 404 error on non existing assets' do
      get :versions, id: 'some_nonexisiting_asset'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check for authorization' do
      get :versions, id: 'some_asset'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should get the versions available for the assets' do
      controller.stub(:authorize!).with(:show, asset) {}
      asset.should_receive(:versions) { {original: [480, 360], small: [240, 180]} }
      get :versions, id: 'some_asset'
      response.status.should == 200
      response.body.should == '{"status":"ok","versions":{"original":[480,360],"small":[240,180]}}'
    end
  end
end