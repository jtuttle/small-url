class UrlController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    small_url = Physical::SmallUrl.create(original_url: params[:url])
    url_token = Logical::UrlTokenEncoder.new.encode(small_url.id.to_s)
    render json: { token: url_token }
  end

  def show
    key = Logical::UrlTokenEncoder.new.decode(params[:token])
    small_url = Physical::SmallUrl.find_by(id: key.to_i)

    if small_url.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    # TODO: This does not handle concurrency, but works for now.
    small_url.increment!(:visit_count)

    redirect_to small_url.original_url
#    render json: { url: small_url.original_url }
  end
end
