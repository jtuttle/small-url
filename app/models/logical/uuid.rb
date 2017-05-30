module Logical
  class Uuid
    def self.regexp
      /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
    end

    def self.generate
      SecureRandom.uuid.downcase
    end
  end
end
