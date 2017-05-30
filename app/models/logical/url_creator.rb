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

      if Logical::UrlValidator.new(@url, safe_browsing_service).valid?
        salt = ('a'..'z').to_a.shuffle[0,8].join
        encrypted_url = Logical::UrlEncryptor.new(salt).encrypt(@url)
        
        small_url =
          Physical::SmallUrl.
            create!({ encrypted_url: encrypted_url, salt: salt, owner_id: owner.id })

        small_url
      else
        raise Exceptions::InvalidUrlError
      end
    end

    private

    def safe_browsing_service
      Remote::GoogleSafeBrowsingService.new
    end
  end
end
