require 'spec_helper'

describe Humpyard::ElementsController do    
  context 'new' do
    let(:new_element) { mock_model(Humpyard::Element, element: 'element_data') }
    let(:prev_element) { mock_model(Humpyard::Element)}
    let(:next_element) { mock_model(Humpyard::Element)}
    
    before do
      Humpyard::config.stub(:element_types) { {'some_element_type' => mock('ElementClass', new: new_element) } }
      Humpyard::Element.stub(:find_by_id).with(nil) { nil }
      Humpyard::Element.stub(:find_by_id).with('prev') { prev_element }
      Humpyard::Element.stub(:find_by_id).with('next') { next_element }
    end
    
    it 'should check for authorization' do
      get :new, type: 'some_element_type'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if element type exists' do
      get :new, type: 'some_nonexisiting_type'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:create, 'element_data') { true }
      get :new, type: 'some_element_type'
      response.status.should == 200
    end
    
    it 'should assign elements' do
      controller.stub(:authorize!).with(:create, 'element_data') { true }
      get :new, type: 'some_element_type'
      assigns[:element].should == new_element
      assigns[:next_element].should be_nil
      assigns[:prev_element].should be_nil
    end
    
    it 'should assign elements with prev and next elements given' do
      controller.stub(:authorize!).with(:create, 'element_data') { true }
      get :new, type: 'some_element_type', prev_id: 'prev', next_id: 'next'
      assigns[:element].should == new_element
      assigns[:next].should == next_element
      assigns[:prev].should == prev_element
    end
    
    it 'should render template' do
      controller.stub(:authorize!).with(:create, 'element_data') { true }
      get :new, type: 'some_element_type'
      response.should render_template(:edit)
    end  
  end
  
  context :create do
    let(:element_data) {mock('SomeElementData', id: 42, to_param: '42')}
    let(:new_element) { mock_model(Humpyard::Element, element: element_data, container: mock('ContainerElement', id: 23)) }
    let(:prev_element) { mock_model(Humpyard::Element)}
    let(:next_element) { mock_model(Humpyard::Element)}
    
    before do
      Humpyard::config.stub(:element_types) { {'some_element_type' => mock('ElementClass', new: new_element) } }
      Humpyard::Element.stub(:find_by_id).with(nil) { nil }
      Humpyard::Element.stub(:find_by_id).with('prev') { prev_element }
      Humpyard::Element.stub(:find_by_id).with('next') { next_element }
      controller.stub(:do_move)
      new_element.stub(:title_for_url=).with('/some/title')
    end
    
    it 'should check for authorization' do
      post :create, type: 'some_element_type'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if element type exists' do
      get :new, type: 'some_nonexisiting_type'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:create, element_data) {  }
      new_element.stub(:save) { false }
      post :create, type: 'some_element_type'
      response.status.should == 200
    end
    
    it 'should assign elements' do
      controller.stub(:authorize!).with(:create, element_data) {  }
      new_element.stub(:save) { true }
      post :create, type: 'some_element_type'
      assigns[:element].should == new_element
      assigns[:next_element].should be_nil
      assigns[:prev_element].should be_nil
    end
    
    it 'should assign elements with prev and next elements given' do
      controller.stub(:authorize!).with(:create, element_data) {  }
      new_element.stub(:save) { true }
      post :create, type: 'some_element_type', prev_id: 'prev', next_id: 'next'
      assigns[:element].should == new_element
      assigns[:next].should == next_element
      assigns[:prev].should == prev_element
    end
    
    it 'should render template for error case' do
      controller.stub(:authorize!).with(:create, element_data) {  }
      new_element.stub(:errors) { {some_field: 'some_value'} }
      new_element.stub(:save) { false }
      post :create, type: 'some_element_type'
      response.body.should == '{"status":"failed","errors":{"some_field":"some_value"}}' 
    end  
    
    it 'should render template for save case' do
      controller.stub(:authorize!).with(:create, element_data) {  }
      new_element.stub(:save) { true }
      post :create, type: 'some_element_type'
      response.body.should == '{"status":"ok","dialog":"close","insert":[{"element":"hy-id-42","url":"/admin/elements/42","parent":"hy-id-23"}]}' 
    end  
  end
  
  context :edit do
    let(:content_data) { mock('SomeElementData', element: 'element_data') }
    let(:element) { mock_model(Humpyard::Element, content_data: content_data) }
   
    before do
      Humpyard::Element.stub(:find).with('some_element') { element }
      Humpyard::Element.stub(:find).with('some_nonexisiting_element') { raise ActiveRecord::RecordNotFound }
    end
    
    it 'should check for authorization' do
      get :edit, id: 'some_element'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if element exists' do
      get :edit, id: 'some_nonexisiting_element'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, element) {}
      get :edit, id: 'some_element'
      response.status.should == 200
    end
    
    it 'should assign elements' do
      controller.stub(:authorize!).with(:update, element) { }
      get :edit, id: 'some_element'
      assigns[:element].should == content_data
    end
        
    it 'should render template' do
      controller.stub(:authorize!).with(:update, element) {  }
      get :edit, id: 'some_element'
      response.should render_template(:edit)
    end
  end  
  
  context :update do
    let(:content_data) { mock('SomeElementData', errors: {}, id: 42, title: 'Some Title') }
    let(:element) { mock_model(Humpyard::Element, content_data: content_data, suggested_title_for_url: '/some/title', id: 45) }
    
    before do
      Humpyard::Element.stub(:find).with('some_element') { element }
      Humpyard::Element.stub(:find).with('some_nonexisiting_element') { raise ActiveRecord::RecordNotFound }
      content_data.stub(:title_for_url=).with('/some/title')
      element.stub(:content_data) { content_data }
    end
    
    it 'should check for authorization' do
      put :update, id: 'some_element'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if element exists' do
      put :update, id: 'some_nonexisiting_element'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, element) { }
      content_data.stub(:update_attributes) { false }
      put :update, id: 'some_element'
      response.status.should == 200
    end
    
    it 'should assign element' do
      controller.stub(:authorize!).with(:update, element) { }
      content_data.stub(:update_attributes) { false }
      put :update, id: 'some_element'
      assigns[:element].should == element
    end
    
    it 'should render template for error case' do
      controller.stub(:authorize!).with(:update, element) { }
      content_data.stub(:errors) { {some_field: 'some_value'} }
      content_data.stub(:update_attributes) { false }
      
      put :update, id: 'some_element'
      response.body.should == '{"status":"failed","errors":{"some_field":"some_value"}}' 
    end  
    
    it 'should render template for save case' do
      controller.stub(:authorize!).with(:update, element) { }
      content_data.stub(:update_attributes) { true }
      content_data.stub(:title_for_url=).with('/some/title') {}
      content_data.stub(:save) { true }
      put :update, id: 'some_element'
      response.body.should == '{"status":"ok","dialog":"close","replace":[{"element":"hy-id-45","url":"/admin/elements/45"}]}' 
    end
  end
  
  context :move do
    let(:element) { mock_model(Humpyard::Element, element: 'element_data') }
    let(:parent_element) { mock_model(Humpyard::Element)}
    let(:prev_element) { mock_model(Humpyard::Element)}
    let(:next_element) { mock_model(Humpyard::Element)}
    
    before do
      Humpyard::Element.stub(:find_by_id) { nil }
      Humpyard::Element.stub(:find).with('some_element') { element }
      Humpyard::Element.stub(:find_by_id).with('parent_element') { parent_element }
      Humpyard::Element.stub(:find_by_id).with('prev') { prev_element }
      Humpyard::Element.stub(:find_by_id).with('next') { next_element }
      Humpyard::Element.stub(:find).with('some_nonexisiting_element') {  raise ActiveRecord::RecordNotFound  }
      
      element.stub(:update_attributes).with(container: nil, page_yield_name: nil)
      element.stub(:update_attributes).with(container: parent_element, page_yield_name: nil)
      controller.stub(:do_move)
    end
    
    it 'should check for authorization' do
      get :move, id: 'some_element'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if element exists' do
      get :move, id: 'some_nonexisiting_element'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, element) { }
      get :move, id: 'some_element'
      response.status.should == 200
    end
    
    it 'should assign element' do
      controller.stub(:authorize!).with(:update, element) { }
      get :move, id: 'some_element'
      assigns[:element].should == element
    end
    
    it 'should assign parent element' do
      controller.stub(:authorize!).with(:update, element) { }
      element.should_receive(:update_attributes).with(container: parent_element, page_yield_name: nil)
      get :move, id: 'some_element', container_id: 'parent_element'
      response.status.should == 200
    end
    
    it 'should move element to given position by previous id' do
      controller.stub(:authorize!).with(:update, element) { }
      controller.should_receive(:do_move).with(element, prev_element, nil)
      get :move, id: 'some_element', prev_id: 'prev'
      response.status.should == 200   
    end
    
    it 'should move element to given position by next id' do
      controller.stub(:authorize!).with(:update, element) { }
      controller.should_receive(:do_move).with(element, nil, next_element)
      get :move, id: 'some_element', next_id: 'next'
      response.status.should == 200   
    end
  end
  
  context :destroy do
    let(:element) { mock_model(Humpyard::Element, element: 'element_data') }
    
    before do
      Humpyard::Element.stub(:find).with('some_element') { element }
      Humpyard::Element.stub(:find).with('some_nonexisiting_element') {  raise ActiveRecord::RecordNotFound  }
    end
    
    it 'should check for authorization' do
      delete :destroy, id: 'some_element'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if element exists' do
      delete :destroy, id: 'some_nonexisiting_element'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:destroy, element) { }
      delete :destroy, id: 'some_element'
      response.status.should == 200
      response.body.should == '{"status":"ok"}'
    end
    
    it 'should assign element' do
      controller.stub(:authorize!).with(:destroy, element) { }
      delete :destroy, id: 'some_element'
      assigns[:element].should == element
    end
    
    it 'should delete element' do
      controller.stub(:authorize!).with(:destroy, element) { }
      element.should_receive(:destroy)
      delete :destroy, id: 'some_element'
      response.status.should == 200
    end
  end
    
  context :show do  
    let(:element) { mock_model(Humpyard::Element) }
    
    before do
      Humpyard::Element.stub(:find).with('some_nonexisiting_element') { raise ActiveRecord::RecordNotFound }
      Humpyard::Element.stub(:find).with('some_element') { element }
    end
    
    it 'should show introduction on default element if no elements was found' do
      get :show, id: 'some_nonexisiting_element'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check for authorization' do
      get :show, id: 'some_element'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should show the asset' do
      controller.stub(:authorize!).with(:show, element) {}
      get :show, id: 'some_element'
      response.status.should == 200
      assigns[:element].should == element
      response.should render_template(:show)
    end
  end
end