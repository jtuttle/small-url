module Exceptions
  class InvalidUrlError < StandardError
    def message
      "Invalid URL."
    end
  end
end
