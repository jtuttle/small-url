class SharesController < RestrictedAccessController
  def index
    @share_service_url = URL_SHORTENER_SERVICE_HOST
  end
end
