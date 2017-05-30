class UrlController < ApplicationController
  api :GET, "/urls", "Returns a list of small URLs for the given owner."
  param :owner_identifier, Logical::Uuid.regexp, "UUID identifer for the owner of the URL."
  def index
    owner = nil
    
    if params[:owner_identifier].present?
      owner = Physical::Owner.
              find_or_create_by(external_identifier: params[:owner_identifier])
    end
    
    @urls = Physical::SmallUrl.where(owner_id: owner.try(:id))
    render 'urls/index.json.jbuilder'
  end

  api :POST, "/url/create", "Creates a new small URL."
  param :url, String, "The URL to be shortened.", required: true
  param :owner_identifier, Logical::Uuid.regexp, "UUID identifer for the owner of the URL."
  error 422, "Invalid URL format."
  def create
    small_url =
      Logical::UrlCreator.new(params[:url], params[:owner_identifier]).create

    raise Exceptions::UrlCreationFailedError if small_url.nil?
    
    render json: { url: "#{request.base_url}/#{small_url.token}" }
  rescue Exceptions::InvalidUrlError, Exceptions::UrlCreationFailedError => e
    log_error(e)
    render json: { error: e.message }, status: 422
  rescue StandardError => e
    log_error(e)
    render json: { error: "Unable to create small URL." }, status: 500
  end

  api :DELETE, "/url/:url_identifier", "Disables the specified URL."
  param :url_identifier, Logical::Uuid.regexp, "The UUID identifier of the URL."
  error 422, "The url_identifier does not match any known small URLs."
  error 422, "Unable to disable the URL."
  def destroy
    small_url =
      Physical::SmallUrl.
      find_by(public_identifier: params[:url_identifier])

    if small_url.nil?
      render json: { error: "Invalid URL identifier." }, status: 422
    else
      if small_url.update_attribute(:disabled, true)
        render json: {}, status: 200
      else
        render json: { error: "Failed to disable URL." }, status: 422
      end
    end
  end

  api :GET, "/:token", "Redirect to the URL that matches the provided token."
  param :token, String, "A small URL token."
  error 404, "The token does not match a known small URL or the small URL is disabled."
  def show
    key = Logical::UrlTokenEncoder.new.decode(params[:token])
    small_url = Physical::SmallUrl.find_by(id: key.to_i)

    if small_url.nil? || small_url.disabled?
      raise ActionController::RoutingError.new('Not Found')
    end

    # TODO: This does not handle concurrency, but works for now.
    small_url.increment!(:visit_count)

    original_url =
      Logical::UrlEncryptor.
      new(small_url.salt).
      decrypt(small_url.encrypted_url)
    
    redirect_to original_url
  end

  private
  
  def log_error(e)
    puts e.to_s
    # Send error to logging service and/or bugtracking service
  end
end
