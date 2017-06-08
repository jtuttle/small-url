module Exceptions
  class TooManyRedirectsError < StandardError
    def message
      "URL produced too many redirects."
    end
  end
end
