module Logical::Validators
  class UrlSafety
    def self.valid?(urls, safety_service)
      safety_service.are_safe?(urls)
    end
  end
end
