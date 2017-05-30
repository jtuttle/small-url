module Exceptions
  class UrlCreationFailedError < StandardError
    def message
      "URL creation failed."
    end
  end
end
