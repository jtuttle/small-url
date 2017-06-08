module Logical
  class UrlRedirectFollower
    def initialize(first_url, max_visits = 5)
      @first_url = first_url
      @max_visits = max_visits
    end

    def follow
      urls = []
      
      current_url = @first_url
      visit_count = 0

      while visit_count < @max_visits
        visit_count += 1

        urls << current_url
        
        response = make_request(current_url)

        if response.nil?
          raise Exceptions::InvalidResponseCodeError
        end

        code = response.code.try(:to_i)
        
        if code == 200
          return urls
        elsif code >= 300 && code < 400
          current_url = response.header['location']
        else
          raise Exceptions::InvalidResponseCodeError
        end
      end

      raise Exceptions::TooManyRedirectsError
    end

    private

    def make_request(url)
      begin
        uri = URI(url)
        request = Net::HTTP.new(uri.host, uri.port)
        request.use_ssl = (uri.scheme == 'https')
        path = (uri.path.empty? ? "/" : uri.path)
        request.request_head(path)
      rescue SocketError
        nil
      end
    end
  end
end
