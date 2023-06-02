class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new

  end

  def create
    user = Physical::User.find_by(username: params[:username])

    if user.present?
      password_hash = Digest::SHA256.new.hexdigest(user.salt + params[:password])

      if user.password == password_hash
        session[:user_id] = user.id
        render json: {}, status: 200
      else
        render json: { error: "Login failed." }, status: 422
      end
    else
      render json: { error: "Login failed." }, status: 422
    end
  end

  def destroy
    session[:user_id] = nil
    render json: {}, status: 200
  end
end
