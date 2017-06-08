class UrlController < ApplicationController
  rescue_from Apipie::ParamInvalid, with: :render_apipie_param_error

  api :POST, "/url/create", "Creates a new small URL."
  param :url, String, "The URL to be shortened.", required: true
  param :owner_identifier, Logical::Uuid.regexp, "UUID identifer for the owner of the URL."
  error 422, "Invalid URL."
  def create
    url = params[:url]

    # Assume http if no protocol given
    url = "http://#{url}" if URI(url).scheme.nil?

    raise Exceptions::InvalidUrlError if
      !Logical::Validators::UrlHost.valid?(url, request.host) ||
      !Logical::Validators::UrlFormat.valid?(url)
    
    url_chain = Logical::UrlRedirectFollower.new(url).follow
    safe_browsing_service = Remote::GoogleSafeBrowsingService.new

    raise Exceptions::InvalidUrlError if
      !Logical::Validators::UrlSafety.valid?(url_chain, safe_browsing_service)
    
    small_url =
      Logical::UrlCreator.new(url_chain.last, params[:owner_identifier]).create

    render json: { url: "#{request.base_url}/#{small_url.token}" }
  rescue Exceptions::InvalidUrlError, Exceptions::UrlCreationFailedError => e
    log_error(e)
    render json: { error: e.message }, status: 422
  end
  
  api :GET, "/urls", "Returns a list of small URLs for the given owner."
  param :owner_identifier, Logical::Uuid.regexp, "UUID identifer for the owner of the URL."
  error 422, "Invalid owner identifier."
  def index
    owner = nil
    
    if params[:owner_identifier].present?
      owner =
        Physical::Owner.
          find_by(external_identifier: params[:owner_identifier])

      raise Exceptions::InvalidOwnerIdentifierError if owner.nil?
    end
    
    @urls =
      Physical::SmallUrl.
        where(owner_id: owner.try(:id)).
        order(created_at: :desc)
    
    render 'urls/index.json.jbuilder'
  rescue Exceptions::InvalidOwnerIdentifierError => e
    log_error(e)
    render json: { error: e.message }, status: 422
  end

  api :DELETE, "/url/:url_identifier", "Disables the specified URL."
  param :url_identifier, Logical::Uuid.regexp, "The UUID identifier of the URL."
  error 422, "Invalid URL identifier."
  def destroy
    small_url =
      Physical::SmallUrl.
        find_by(public_identifier: params[:url_identifier])
    
    raise Exceptions::InvalidUrlIdentifierError if small_url.nil?
    
    small_url.update!(disabled: true)
    
    render json: {}, status: 200
  rescue Exceptions::InvalidUrlIdentifierError => e
    log_error(e)
    render json: { error: e.message }, status: 422
  end

  api :GET, "/:token", "Redirect to the URL that matches the provided token."
  param :token, String, "A small URL token."
  error 404, "Invalid URL token or URL is disabled."
  def show
    url_key = Logical::UrlTokenEncoder.new.decode(params[:token])
    small_url = Physical::SmallUrl.find_by(id: url_key.to_i)

    raise Exceptions::InvalidUrlTokenError if small_url.nil?
    raise Exceptions::UrlDisabledError if small_url.disabled?

    # TODO: This does not handle concurrency, but works for now.
    small_url.increment!(:visit_count)

    original_url =
      Logical::UrlEncryptor.
      new(small_url.salt).
      decrypt(small_url.encrypted_url)

    # FTP broken!
    redirect_to original_url
  rescue Exceptions::InvalidUrlTokenError, Exceptions::UrlDisabledError, StandardError => e
    log_error(e)
    raise ActionController::RoutingError.new("URL redirect failed.")
  end

  private

  def log_error(e)
    Rails.logger.error(e.message)
    
    # TODO: Send error to logging service and/or bugtracking service
  end

  # Prevent Apipie param errors from including backtrace in the error response.
  def render_apipie_param_error(e)
    render json: { error: e.message }, status: 500
  end
end
