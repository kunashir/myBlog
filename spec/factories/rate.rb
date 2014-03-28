FactoryGirl.define do
  factory :rate do
    association :area, factory: :lipetsk
    association :city
    carcase "термос"
    summa 55000
  end
end