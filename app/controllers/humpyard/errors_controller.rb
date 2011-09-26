# coding: utf-8
class Humpyard::ErrorsController < ApplicationController
  def error404
    # raise ActionController::RoutingError, "No route matches \"#{request.path}\""
    @page = ::Humpyard::Page.new()
    render '/humpyard/pages/not_found', status: 404
  end
end