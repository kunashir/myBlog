FactoryGirl.define do
  factory :company do
    name "Roshen"
    is_freighter false
  end

  factory :fr, class: Company do
    name "transline"
    is_freighter true
  end

  factory :waste_byer, class: Company do
    name "roga and copita"
    is_freighter false
    is_waste_byer true
  end

  factory :other_seller, class: Company do
    name "roga and copita"
    is_freighter false
    is_other_seller true
  end

end