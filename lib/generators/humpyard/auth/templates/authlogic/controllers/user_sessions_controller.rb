class <%= class_name %>SessionsController < ApplicationController
  def new
    @user_session = <%= class_name %>Session.new
  end

  def create
    @user_session = <%= class_name %>Session.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def destroy
    @user_session = <%= class_name %>Session.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end