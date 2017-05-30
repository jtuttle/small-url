module Exceptions
  class InvalidUrlIdentifierError < StandardError
    def message
      "Invalid URL identifier."
    end
  end
end
