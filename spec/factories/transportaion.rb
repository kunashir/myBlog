FactoryGirl.define do
  factory :transportation do
    num "1234"
    date Date.tomorrow
    time "09:00"
    #association :storage_source
    association :storage_dist, factory: :storage
    comment "Comment"

    #type_transp "реф"
    weight 30
    volume 13
    carcase "реф"
    start_sum "1000"
    cur_sum 0
    step 500
    company nil
    association :client
    association :area
    association :user
  end
end