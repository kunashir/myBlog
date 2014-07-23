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
    start_sum 10000
    cur_sum 0
    step 500
    company nil
    association :client
    association :area
    association :user
  end

  #The transportation on complex direction (2 or more points) and extra pay for this
  factory :tr_extra, class: Transportation do
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
    extra_pay 500
    complex_direction true
    cur_sum 0
    step 500
    company nil
    association :client
    association :area
    association :user
  end
end