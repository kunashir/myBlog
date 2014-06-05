FactoryGirl.define do
  factory :company do
    name "Roshen"
    is_freighter false
  end

  factory :fr, class: Company do
    name
    is_freighter true
    # after :build do |fr, evaluator|
    #     fr.users << FactoryGirl.build_list(:user, 5)
    # end
  end

end