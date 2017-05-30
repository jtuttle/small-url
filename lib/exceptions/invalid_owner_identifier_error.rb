module Exceptions
  class InvalidOwnerIdentifierError < StandardError
    def message
      "Invalid owner identifier."
    end
  end
end
