FactoryGirl.define do
  factory :company do
    name "Roshen"
    is_freighter false
  end

  factory :fr, class: Company do
    name "transline"
    is_freighter true
  end

end