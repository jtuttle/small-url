module Logical
  class UrlCreator
    def initialize(url, owner_identifier)
      @url = url
      @owner_identifier = owner_identifier
    end

    def create
      if @owner_identifier
        owner =
          Physical::Owner.
            find_or_create_by(external_identifier: @owner_identifier)
      end
      
      salt = SecureRandom.hex(32)
      encrypted_url = Logical::UrlEncryptor.new(salt).encrypt(@url)
      
      Physical::SmallUrl.
        create!({ encrypted_url: encrypted_url, salt: salt, owner_id: owner.try(:id) })
    end
  end
end
