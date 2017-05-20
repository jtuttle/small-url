module Logical
  class UrlTokenEncoder
    ALPHABET = 'bcdfghjklmnpqrstvwxz0123456789'.split('')
    
    def encode(key)
      Bases.val(key.to_s).in_base(10).to_base(ALPHABET)
    end

    def decode(token)
      Bases.val(token).in_base(ALPHABET).to_base(10)
    end
  end
end
