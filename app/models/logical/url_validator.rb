require 'net/http'

module Logical
  class UrlValidator
    def initialize(url, safety_service)
      @url = URI.parse(url)
      @safety_service = safety_service
    end

    def valid?
      format_valid? && safety_valid? && response_valid?
    end

    private

    def format_valid?
      !@url.host.nil?
    end

    def safety_valid?
      safety_service.is_safe?(@url)
    end

    def response_valid?
      # TODO: Update this to use RestClient.
      begin
        request = Net::HTTP.new(@url.host, @url.port)
        request.use_ssl = (@url.scheme == 'https')
        path = (@url.path.empty? ? "/" : @url.path)
        response = request.request_head(path)
        response.code != '404'
      rescue
        false
      end
    end
  end
end
