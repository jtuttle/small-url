FactoryGirl.define do
  factory :owner, class: Physical::Owner do
    external_identifier Logical::Uuid.generate
  end
end
