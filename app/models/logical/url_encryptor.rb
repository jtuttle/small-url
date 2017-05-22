module Logical
  class UrlEncryptor
    def initialize(salt)
      @salt = salt
    end
    
    def encrypt(url)
      encryptor.encrypt_and_sign(url)
    end

    def decrypt(encrypted_url)
      encryptor.decrypt_and_verify(encrypted_url)
    end

    private

    def encryptor
      ActiveSupport::MessageEncryptor.new(key)
    end

    def key
      ActiveSupport::KeyGenerator.
        new(Rails.application.secrets.secret_key_base).
        generate_key(@salt, 32)
    end
  end
end
