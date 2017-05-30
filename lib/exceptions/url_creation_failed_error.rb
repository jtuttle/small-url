module Exceptions
  class UrlCreationFailedError < StandardError
    def message
      "Unable to create small URL."
    end
  end
end
