require 'spec_helper'

describe 'routes for 404 errors' do
  it { { get: '/en/some_path/some_not_existing_path'}.should route_to(controller: 'humpyard/errors', action: 'error404', path: 'some_path/some_page', locale: 'en') }
end