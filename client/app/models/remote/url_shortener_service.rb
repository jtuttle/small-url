module Remote
  class UrlShortenerService
    def initialize

    end

    def service_url
      URL_SHORTENER_SERVICE_HOST
    end

    def create_short_url(long_url)
      response = RestClient.post("#{service_url}/url/create", { url: long_url })
      JSON.parse(response)
    end

    def get_urls
      response = RestClient.get("#{service_url}/urls")
      JSON.parse(response)["urls"]
    end
  end
end
