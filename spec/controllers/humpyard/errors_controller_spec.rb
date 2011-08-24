require 'spec_helper'

describe Humpyard::ErrorsController do    
  context 'error404' do
    it 'should raise an routing error' do
      controller.stub(:request) { mock('Request', path: '/non_existing_path/') }
      lambda {controller.send('error404')}.should raise_error(ActionController::RoutingError, 'No route matches "/non_existing_path/"')
    end
  end
end