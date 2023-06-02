module Exceptions
  class InvalidUrlTokenError < StandardError
    def message
      "Invalid URL token."
    end
  end
end
