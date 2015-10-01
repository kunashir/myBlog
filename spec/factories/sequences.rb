FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "name#{n}"
  end

  sequence :content do |n|
    "Message #{n}"
  end

end