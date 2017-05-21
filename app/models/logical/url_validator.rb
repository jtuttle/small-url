require 'net/http'

module Logical
  class UrlValidator
    def initialize(url)
      @url = URI.parse(url)
    end

    def valid?
      format_valid? && response_valid?
    end

    private

    def format_valid?
      !@url.host.nil?
    end

    def response_valid?
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
