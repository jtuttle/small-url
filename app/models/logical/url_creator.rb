module Logical
  class UrlCreator
    def initialize(url, owner_identifier)
      @url = url
      @owner_identifier = owner_identifier
    end

    def create
      owner =
        Physical::Owner.
          find_or_create_by(external_identifier: @owner_identifier)
      
      salt = SecureRandom.hex
      encrypted_url = Logical::UrlEncryptor.new(salt).encrypt(@url)
      
      Physical::SmallUrl.
        create!({ encrypted_url: encrypted_url, salt: salt, owner_id: owner.id })
    end
  end
end
