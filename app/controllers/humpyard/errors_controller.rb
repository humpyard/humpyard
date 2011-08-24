# coding: utf-8
class Humpyard::ErrorsController < ApplicationController
  def error404
    raise ActionController::RoutingError, "No route matches \"#{request.path}\""
  end
end