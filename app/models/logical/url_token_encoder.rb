module Logical
  class UrlTokenEncoder
    ALPHABET = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a) - "aeiouAEIOU".split('')

    def encode(key)
      Bases.val(key.to_s).in_base(10).to_base(ALPHABET)
    end

    def decode(token)
      Bases.val(token).in_base(ALPHABET).to_base(10)
    end
  end
end
