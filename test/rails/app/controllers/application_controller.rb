class ApplicationController < ActionController::Base
  helper_method :current_user

  # Handle AccessDenied exception of CanCan
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private
  def current_user
    if not @current_user.nil?
      @current_user
    else
      session[:humpyard] ||= {}
      unless params[:user].nil?
        session[:humpyard][:user] = params[:user].blank? ? false : params[:user]
      end
      @current_user = session[:humpyard][:user] || false
    end
  end
  protect_from_forgery
end
