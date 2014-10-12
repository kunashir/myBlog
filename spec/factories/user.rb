FactoryGirl.define do

  factory :user do
    email
    password 'password'
    association :company, factory: :fr
    name "some user"
  end

  factory :manager, class: User do
    email "admin@roshen.ru"
    password 'password'
    association :company
    name "manager"
    nmanager true
  end

end