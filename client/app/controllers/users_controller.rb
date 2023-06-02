class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
    
  end

  def create
    if params[:username].length < 6
      render json: { error: "Username too short." }, status: 422
    elsif params[:password].length < 8
      render json: { error: "Password too short." }, status: 422
    elsif Physical::User.exists?(username: params[:username])
      render json: { error: "Username taken." }, status: 422
    else
      salt = SecureRandom.hex(32)
      
      user_params = {
        username: params[:username],
        salt: salt,
        password: Digest::SHA256.new.hexdigest(salt + params[:password])
      }

      Physical::User.create(user_params)

      render json: {}, status: 200
    end
  end
end
