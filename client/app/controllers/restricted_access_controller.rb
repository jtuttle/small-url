class RestrictedAccessController < ApplicationController
  before_action :verify_login

  def verify_login
    redirect_to login_path unless !!current_user
  end
  
  private
  
  def current_user
    if session[:user_id]
      @current_user = Physical::User.find(session[:user_id])
      @current_user
    else
      false
    end      
  end
end
