FactoryGirl.define do
  factory :city do
    name "Some city"
  end

  factory :lipetsk, class: City do
    name "Lipetsk"
  end
end