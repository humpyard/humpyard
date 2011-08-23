require 'spec_helper'

describe Humpyard::PagesController do    
  context 'index' do
    let(:root_page) { mock_model(Humpyard::Page) }
    let(:page) { mock_model(Humpyard::Page) }
  
    before do
      Humpyard::Page.stub(:root) { root_page }
      Humpyard::Page.stub(:find_by_id) { page }
      page.stub(:content_data) { 'content_data' }
    end
    
    
    it 'should check for authorization' do
      get :index
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:manage, Humpyard::Page) {}
      get :index
      response.status.should == 200
    end
    
    it 'should assign root page' do
      controller.stub(:authorize!).with(:manage, Humpyard::Page) {}
      get :index
      assigns[:root_page].should == root_page
    end
    
    it 'should assign page content data' do
      controller.stub(:authorize!).with(:manage, Humpyard::Page) {}
      get :index
      assigns[:page].should == 'content_data'
    end
    
    it 'should render template' do
      controller.stub(:authorize!).with(:manage, Humpyard::Page) {}
      get :index
      response.should render_template(:index)
    end   
  end
  
  context 'new' do
    let(:new_page) { mock_model(Humpyard::Page, page: 'page_data') }
    let(:prev_page) { mock_model(Humpyard::Page)}
    let(:next_page) { mock_model(Humpyard::Page)}
    
    before do
      Humpyard::config.stub(:page_types) { {'some_page_type' => mock('PageClass', new: new_page) } }
      Humpyard::Page.stub(:find_by_id).with(nil) { nil }
      Humpyard::Page.stub(:find_by_id).with('prev') { prev_page }
      Humpyard::Page.stub(:find_by_id).with('next') { next_page }
    end
    
    it 'should check for authorization' do
      get :new, type: 'some_page_type'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if page type exists' do
      get :new, type: 'some_nonexisiting_type'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:create, 'page_data') { true }
      get :new, type: 'some_page_type'
      response.status.should == 200
    end
    
    it 'should assign pages' do
      controller.stub(:authorize!).with(:create, 'page_data') { true }
      get :new, type: 'some_page_type'
      assigns[:page].should == new_page
      assigns[:next_page].should be_nil
      assigns[:prev_page].should be_nil
    end
    
    it 'should assign pages with prev and next pages given' do
      controller.stub(:authorize!).with(:create, 'page_data') { true }
      get :new, type: 'some_page_type', prev_id: 'prev', next_id: 'next'
      assigns[:page].should == new_page
      assigns[:next].should == next_page
      assigns[:prev].should == prev_page
    end
    
    it 'should render template' do
      controller.stub(:authorize!).with(:create, 'page_data') { true }
      get :new, type: 'some_page_type'
      response.should render_template(:edit)
    end  
  end
  
  context :create do
    let(:page_data) {mock('SomePageData', suggested_title_for_url: '/some/title')}
    let(:new_page) { mock_model(Humpyard::Page, page: page_data) }
    let(:prev_page) { mock_model(Humpyard::Page)}
    let(:next_page) { mock_model(Humpyard::Page)}
    
    before do
      Humpyard::config.stub(:page_types) { {'some_page_type' => mock('PageClass', new: new_page) } }
      Humpyard::Page.stub(:find_by_id).with(nil) { nil }
      Humpyard::Page.stub(:find_by_id).with('prev') { prev_page }
      Humpyard::Page.stub(:find_by_id).with('next') { next_page }
      new_page.stub(:title_for_url=).with('/some/title')
    end
    
    it 'should check for authorization' do
      post :create, type: 'some_page_type'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if page type exists' do
      get :new, type: 'some_nonexisiting_type'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:create, page_data) {  }
      new_page.stub(:save) { false }
      post :create, type: 'some_page_type'
      response.status.should == 200
    end
    
    it 'should assign pages' do
      controller.stub(:authorize!).with(:create, page_data) {  }
      new_page.stub(:save) { true }
      post :create, type: 'some_page_type'
      assigns[:page].should == new_page
      assigns[:next_page].should be_nil
      assigns[:prev_page].should be_nil
    end
    
    it 'should assign pages with prev and next pages given' do
      controller.stub(:authorize!).with(:create, page_data) {  }
      new_page.stub(:save) { true }
      post :create, type: 'some_page_type', prev_id: 'prev', next_id: 'next'
      assigns[:page].should == new_page
      assigns[:next].should == next_page
      assigns[:prev].should == prev_page
    end
    
    it 'should render template for error case' do
      controller.stub(:authorize!).with(:create, page_data) {  }
      new_page.stub(:errors) { {some_field: 'some_value'} }
      new_page.stub(:save) { false }
      post :create, type: 'some_page_type'
      response.body.should == '{"status":"failed","errors":{"some_field":"some_value"},"flash":{"level":"error","content":"Failed to create page!"}}' 
    end  
    
    it 'should render template for save case' do
      controller.stub(:authorize!).with(:create, page_data) {  }
      new_page.stub(:save) { true }
      post :create, type: 'some_page_type'
      response.body.should == '{"status":"ok","replace":[{"element":"hy-page-treeview","content":""}],"flash":{"level":"info","content":"Successfully created page."}}' 
      response.should render_template(:tree)
    end  
  end
  
  context :edit do
    let(:content_data) { mock('SomePageData', page: 'page_data') }
    let(:page) { mock_model(Humpyard::Page, content_data: content_data) }
   
    before do
      Humpyard::Page.stub(:find).with('some_page') { page }
      Humpyard::Page.stub(:find).with('some_nonexisiting_page') { raise ActiveRecord::RecordNotFound }
    end
    
    it 'should check for authorization' do
      get :edit, id: 'some_page'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if page exists' do
      get :edit, id: 'some_nonexisiting_page'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, page) {}
      get :edit, id: 'some_page'
      response.status.should == 200
    end
    
    it 'should assign pages' do
      controller.stub(:authorize!).with(:update, page) { }
      get :edit, id: 'some_page'
      assigns[:page].should == content_data
    end
        
    it 'should render template' do
      controller.stub(:authorize!).with(:update, page) {  }
      get :edit, id: 'some_page'
      response.should render_template(:edit)
    end
  end  
  
  context :update do
    let(:content_data) { mock('SomePageData', errors: {}, id: 42, title: 'Some Title') }
    let(:page) { mock_model(Humpyard::Page, content_data: content_data, suggested_title_for_url: '/some/title') }
    
    before do
      Humpyard::Page.stub(:find).with('some_page') { page }
      Humpyard::Page.stub(:find).with('some_nonexisiting_page') { raise ActiveRecord::RecordNotFound }
      content_data.stub(:title_for_url=).with('/some/title')
      page.stub(:content_data) { content_data }
    end
    
    it 'should check for authorization' do
      put :update, id: 'some_page'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if page exists' do
      put :update, id: 'some_nonexisiting_page'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, page) { }
      content_data.stub(:update_attributes) { false }
      put :update, id: 'some_page'
      response.status.should == 200
    end
    
    it 'should assign page' do
      controller.stub(:authorize!).with(:update, page) { }
      content_data.stub(:update_attributes) { false }
      put :update, id: 'some_page'
      assigns[:page].should == content_data
    end
    
    it 'should render template for error case' do
      controller.stub(:authorize!).with(:update, page) { }
      content_data.stub(:errors) { {some_field: 'some_value'} }
      content_data.stub(:update_attributes) { false }
      
      put :update, id: 'some_page'
      response.body.should == '{"status":"failed","errors":{"some_field":"some_value"},"flash":{"level":"error","content":"Failed to update page!"}}' 
    end  
    
    it 'should render template for save case' do
      controller.stub(:authorize!).with(:update, page) { }
      content_data.stub(:update_attributes) { true }
      content_data.stub(:title_for_url=).with('/some/title') {}
      content_data.stub(:save) { true }
      put :update, id: 'some_page'
      response.body.should == '{"status":"ok","replace":[{"element":"hy-page-treeview-text-42","content":"Some Title"}],"flash":{"level":"info","content":"Successfully updated page."}}' 
    end
  end
  
  context :move do
    let(:page) { mock_model(Humpyard::Page, page: 'page_data') }
    let(:parent_page) { mock_model(Humpyard::Page)}
    let(:prev_page) { mock_model(Humpyard::Page)}
    let(:next_page) { mock_model(Humpyard::Page)}
    
    before do
      Humpyard::Page.stub(:find_by_id) { nil }
      Humpyard::Page.stub(:find).with('some_page') { page }
      Humpyard::Page.stub(:find_by_id).with('parent_page') { parent_page }
      Humpyard::Page.stub(:find_by_id).with('prev') { prev_page }
      Humpyard::Page.stub(:find_by_id).with('next') { next_page }
      Humpyard::Page.stub(:find).with('some_nonexisiting_page') {  raise ActiveRecord::RecordNotFound  }
      
      page.stub(:update_attribute).with(:parent, nil)
      page.stub(:update_attribute).with(:parent, parent_page)
      controller.stub(:do_move)
    end
    
    it 'should check for authorization' do
      get :move, id: 'some_page'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if page exists' do
      get :move, id: 'some_nonexisiting_page'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:update, page) { }
      get :move, id: 'some_page'
      response.status.should == 200
    end
    
    it 'should assign page' do
      controller.stub(:authorize!).with(:update, page) { }
      get :move, id: 'some_page'
      assigns[:page].should == page
    end
    
    it 'should assign parent page' do
      controller.stub(:authorize!).with(:update, page) { }
      page.should_receive(:update_attribute).with(:parent, parent_page)
      get :move, id: 'some_page', parent_id: 'parent_page'
      response.status.should == 200
    end
    
    it 'should move page to given position by previous id' do
      controller.stub(:authorize!).with(:update, page) { }
      controller.should_receive(:do_move).with(page, prev_page, nil)
      get :move, id: 'some_page', prev_id: 'prev'
      response.status.should == 200   
    end
    
    it 'should move page to given position by next id' do
      controller.stub(:authorize!).with(:update, page) { }
      controller.should_receive(:do_move).with(page, nil, next_page)
      get :move, id: 'some_page', next_id: 'next'
      response.status.should == 200   
    end
  end
  
  context :destroy do
    let(:page) { mock_model(Humpyard::Page, page: 'page_data') }
    
    before do
      Humpyard::Page.stub(:find).with('some_page') { page }
      Humpyard::Page.stub(:find).with('some_nonexisiting_page') {  raise ActiveRecord::RecordNotFound  }
    end
    
    it 'should check for authorization' do
      delete :destroy, id: 'some_page'
      response.status.should == 403
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should check if page exists' do
      delete :destroy, id: 'some_nonexisiting_page'
      response.status.should == 404
      response.body.should == '{"status":"failed"}'
    end
    
    it 'should allow access if authorized' do
      controller.stub(:authorize!).with(:destroy, page) { }
      delete :destroy, id: 'some_page'
      response.status.should == 200
      response.body.should == '{"status":"ok"}'
    end
    
    it 'should assign page' do
      controller.stub(:authorize!).with(:destroy, page) { }
      delete :destroy, id: 'some_page'
      assigns[:page].should == page
    end
    
    it 'should delete page' do
      controller.stub(:authorize!).with(:destroy, page) { }
      page.should_receive(:destroy)
      delete :destroy, id: 'some_page'
      response.status.should == 200
    end
  end
  
  context :show do
    let(:first_level_content_data) { mock('SomePageData', 
      is_humpyard_dynamic_page?: false, 
      is_humpyard_virtual_page?: false
    ) }
    let(:content_data) { mock('SomePageData', 
      is_humpyard_dynamic_page?: false, 
      is_humpyard_virtual_page?: false
    ) }
    
    let(:first_level_page) { mock_model(Humpyard::Page, 
      parent: nil, 
      is_root_page?: false, 
      content_data: first_level_content_data, 
      last_modified: '2010-02-23 11:23 pm'.to_time, 
      content_data_type: 'SomePageData',
      template_name: 'application'
    ) }
    let(:page) { mock_model(Humpyard::Page, 
      parent: first_level_page, 
      is_root_page?: false, 
      content_data: content_data, 
      last_modified: '2010-04-02 00:42'.to_time, 
      content_data_type: 'SomePageData',
      template_name: 'application'
    ) }
    
    it 'should show introduction on default page if no pages was found' do
      get :show, id: 123
      response.status.should == 200
      response.should render_template('/humpyard/pages/welcome')
      assigns[:page].class.should == Humpyard::Page
    end
    
    it 'should show introduction on index page if no pages was found' do
      get :show, webpath: 'index'
      response.status.should == 200
      response.should render_template('/humpyard/pages/welcome')
      assigns[:page].class.should == Humpyard::Page
    end
    
    it 'should raise 404 if no pages was found' do
      get :show, webpath: 'not_the_index', locale: 'en', format: 'html'
      response.status.should == 404
      response.should_not render_template('/humpyard/pages/welcome')
    end
    
    it 'should show a page by web path' do
      Humpyard::Page.should_receive(:with_translated_attribute).with(:title_for_url, 'some_page', :en) { [first_level_page] }
      get :show, webpath: 'some_page', locale: 'en', format: 'html'
      response.status.should == 200
      assigns[:page].should == first_level_page
    end
    
    it 'should show a sub page by web path' do
      Humpyard::Page.should_receive(:with_translated_attribute).with(:title_for_url, 'another_page', :en) { [first_level_page] }
      Humpyard::Page.should_receive(:with_translated_attribute).with(:title_for_url, 'and_yet_another_one', :en) { [page] }
      get :show, webpath: 'another_page/and_yet_another_one', locale: 'en', format: 'html'
      response.status.should == 200
      assigns[:page].should == page
    end
  end
  
  context :sitemap do
  end
end