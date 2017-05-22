class UrlController < ApplicationController
  def index
    owner =
      Physical::Owner.
      find_or_create_by(external_identifier: params[:owner_identifier])

    if owner.nil?
      render json: { error: "Invalid owner." }, status: 422
    else
      @urls = owner.small_urls.order(created_at: :desc)
      render 'urls/index.json.jbuilder'
    end
  end
  
  def create
    url = params[:url]

    owner =
      Physical::Owner.
      find_or_create_by(external_identifier: params[:owner_identifier])

    if Logical::UrlValidator.new(url).valid?
      salt = ('a'..'z').to_a.shuffle[0,8].join
      encrypted_url = Logical::UrlEncryptor.new(salt).encrypt(url)
      
      small_url =
        Physical::SmallUrl.
        create({ original_url: encrypted_url, salt: salt, owner_id: owner.id })

      url_token = Logical::UrlTokenEncoder.new.encode(small_url.id.to_s)
     
      render json: { url: "#{request.base_url}/#{url_token}" }
    else
      render json: { error: "Invalid URL." }, status: 422
    end
  end

  def destroy
    small_url =
      Physical::SmallUrl.
      find_by(public_identifier: params[:url_identifier])

    if small_url.nil?
      render json: { error: "Invalid token." }, status: 422
    else
      if small_url.update_attribute(:disabled, true)
        render json: {}, status: 200
      else
        render json: { error: "Failed to disable URL." }, status: 422
      end
    end
  end

  def show
    key = Logical::UrlTokenEncoder.new.decode(params[:token])
    small_url = Physical::SmallUrl.find_by(id: key.to_i)

    if small_url.nil? || small_url.disabled?
      raise ActionController::RoutingError.new('Not Found')
    end

    # TODO: This does not handle concurrency, but works for now.
    small_url.increment!(:visit_count)

    redirect_to small_url.original_url
  end
end
