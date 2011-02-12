# coding: utf-8
class Humpyard::ErrorsController < ApplicationController
  helper 'humpyard::pages'
  
  def error404
    raise ActionController::RoutingError, "No route matches \"#{request.path}\""
  end
end