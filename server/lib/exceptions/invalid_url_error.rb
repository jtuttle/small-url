module Exceptions
  class InvalidUrlError < StandardError
    def message
      "Invalid URL. Make sure to include the correct protocol prefix."
    end
  end
end
