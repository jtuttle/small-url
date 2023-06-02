module Physical
  class SmallUrl < ActiveRecord::Base
    belongs_to :owner, optional: true

    def token
      Logical::UrlTokenEncoder.new.encode(id.to_s)
    end
  end
end
