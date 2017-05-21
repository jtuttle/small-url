module Physical
  class SmallUrl < ActiveRecord::Base
    belongs_to :owner
  end
end
