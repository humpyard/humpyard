require 'spec_helper'

describe 'routes for asset admin backend' do  
  it { humpyard_assets_path.should == '/admin/assets' }
  it { { get: '/admin/assets'}.should route_to(controller: 'humpyard/assets', action: 'index') }
  
  it { new_humpyard_asset_path.should == '/admin/assets/new' }
  it { { get: '/admin/assets/new'}.should route_to(controller: 'humpyard/assets', action: 'new') }
  it { { post: '/admin/assets'}.should route_to(controller: 'humpyard/assets', action: 'create') }
  
  it { edit_humpyard_asset_path(42).should == '/admin/assets/42/edit' }
  it { { get: '/admin/assets/42/edit'}.should route_to(controller: 'humpyard/assets', action: 'edit', id: '42') }
  it { { put: '/admin/assets/42'}.should route_to(controller: 'humpyard/assets', action: 'update', id: '42') }
  
  it { { delete: '/admin/assets/42'}.should route_to(controller: 'humpyard/assets', action: 'destroy', id: '42') }
    
  it { humpyard_asset_path(42).should == '/admin/assets/42' }
  it { { get: '/admin/assets/42'}.should route_to(controller: 'humpyard/assets', action: 'show', id: '42') }
  
  it { versions_humpyard_asset_path(42).should == '/admin/assets/42/versions' }
  it { { get: '/admin/assets/42/versions'}.should route_to(controller: 'humpyard/assets', action: 'versions', id: '42') }
  
end