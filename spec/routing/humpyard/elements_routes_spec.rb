require 'spec_helper'

describe 'routes for element admin backend' do  
  it { new_humpyard_element_path.should == '/admin/elements/new' }
  it { { get: '/admin/elements/new'}.should route_to(controller: 'humpyard/elements', action: 'new') }
  it { { post: '/admin/elements'}.should route_to(controller: 'humpyard/elements', action: 'create') }
  
  it { edit_humpyard_element_path(42).should == '/admin/elements/42/edit' }
  it { { get: '/admin/elements/42/edit'}.should route_to(controller: 'humpyard/elements', action: 'edit', id: '42') }
  it { { put: '/admin/elements/42'}.should route_to(controller: 'humpyard/elements', action: 'update', id: '42') }
  
  it { { delete: '/admin/elements/42'}.should route_to(controller: 'humpyard/elements', action: 'destroy', id: '42') }
  
  it { inline_edit_humpyard_element_path(42).should == '/admin/elements/42/inline_edit' }
  it { { get: '/admin/elements/42/inline_edit'}.should route_to(controller: 'humpyard/elements', action: 'inline_edit', id: '42') }
  
  
  it { move_humpyard_element_path(42).should == '/admin/elements/42/move' }
  it { { post: '/admin/elements/42/move'}.should route_to(controller: 'humpyard/elements', action: 'move', id: '42')}
  
  it { humpyard_element_path(42).should == '/admin/elements/42' }
  it { { get: '/admin/elements/42'}.should route_to(controller: 'humpyard/elements', action: 'show', id: '42') }
end