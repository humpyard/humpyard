class <%= class_name %>SessionsController < ApplicationController
  helper 'humpyard::pages'
  
  def new
    @page = Humpyard::Page.new(
      :title => I18n.t('humpyard_cms.login.title'), 
      :always_refresh => true, 
      :modified_at => Time.now, 
      :searchable => false
    )
  end
  
  def create
    unless params[:username].blank? or params[:password].blank?
      require 'digest/sha1'
      
      users = YAML::load(File.open("#{RAILS_ROOT}/config/humpyard_users.yml"))
      
      if users and "#{users[params[:username]]}" == Digest::SHA1.hexdigest(params[:password])
        @current_user = params[:username]
        session[:humpyard] ||= {}
        session[:humpyard][:user] = @current_user
        redirect_to "/#{Humpyard::config.www_prefix}"
        return
      end
    end
    
    @login_error = true
    new
    render "new"
  end
  
  def destroy
    @current_user = nil
    session[:humpyard] ||= {}
    session[:humpyard][:user] = @current_user
    redirect_to "/#{Humpyard::config.www_prefix}"
  end
end