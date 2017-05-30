module Physical
  class SmallUrl < ActiveRecord::Base
    belongs_to :owner

    def token
      Logical::UrlTokenEncoder.new.encode(id.to_s)
    end
  end
end
