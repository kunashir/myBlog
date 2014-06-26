FactoryGirl.define do

  factory :user do
    email
    password 'password'
    #association :company, factory: :fr
    after :build do |fr, evaluator|
        fr.company = FactoryGirl.create(:fr)
    end
    name "some user"
    is_block false
    show_reg false
  end

  factory :manager, class: User do
    email "admin@roshen.ru"
    password 'password'
    association :company
    name "manager"
    nmanager true
  end

end