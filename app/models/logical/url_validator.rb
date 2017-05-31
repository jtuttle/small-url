require 'net/http'

module Logical
  class UrlValidator
    def initialize(url, request_host, safety_service)
      @url = URI.parse(url)
      @request_host = request_host
      @safety_service = safety_service
    end

    def valid?
      host_valid? && format_valid? && safety_valid? && response_valid?
    end

    private

    def host_valid?
      @url.host != @request_host
    end
    
    def format_valid?
      !@url.host.nil?
    end

    def safety_valid?
      @safety_service.is_safe?(@url)
    end

    def response_valid?
      # TODO: Update this to use RestClient.
      begin
        request = Net::HTTP.new(@url.host, @url.port)
        request.use_ssl = (@url.scheme == 'https')
        path = (@url.path.empty? ? "/" : @url.path)
        response = request.request_head(path)

        # Note this disallows http <=> https redirects
        # so URL must be very explicit.
        response.code == '200'
      rescue
        false
      end
    end
  end
end
