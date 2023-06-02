module Exceptions
  class UrlDisabledError < StandardError
    def message
      "URL disabled."
    end
  end
end
