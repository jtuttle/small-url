module Exceptions
  class InvalidResponseCodeError < StandardError
    def message
      "URL produced an invalid response code."
    end
  end
end
