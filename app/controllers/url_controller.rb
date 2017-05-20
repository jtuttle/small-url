class UrlController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create

    render json: { test: true }
  end

  def show

    render json: { test: true }
  end
end
