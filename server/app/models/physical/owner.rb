module Physical
  class Owner < ActiveRecord::Base
    has_many :small_urls
  end
end
