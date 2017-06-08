module Logical::Validators
  class UrlFormat
    def self.valid?(url)
      uri = URI(url)
      uri.scheme.present? && uri.host.present?
    end
  end
end
