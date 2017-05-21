class UrlController < ApplicationController
  def index
    owner_id = params[:owner_identifier]
    
    @urls =
      Physical::SmallUrl.
      where(owner_identifier: owner_id).
      order(created_at: :desc)

    render 'urls/index.json.jbuilder'
  end
  
  def create
    url = params[:url]
    owner_id = params[:owner_identifier]

    if Logical::UrlValidator.new(url).valid?
      small_url =
        Physical::SmallUrl.
        create(original_url: url, owner_identifier: owner_id)
      
      url_token = Logical::UrlTokenEncoder.new.encode(small_url.id.to_s)
      
      render json: { url: "#{request.base_url}/#{url_token}" }
    else
      render json: { error: "Invalid URL." }, status: 422
    end
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
  end
end
