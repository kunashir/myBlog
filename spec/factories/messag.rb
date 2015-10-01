FactoryGirl.define do
  factory :message do
    content
  end

  factory :user_msg do
    association :user
    association :message
  end
end