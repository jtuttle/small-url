module Logical::Validators
  class UrlHost
    def self.valid?(url, request_host)
      URI(url).host != request_host
    end
  end
end
