FactoryGirl.define do

  factory :user do
    email
    password 'password'
    association :company
    name "some user"
  end

end