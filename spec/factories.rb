require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    sequence(:password) { |n| "password#{n}" }
  end

  factory :elevator do
    sequence(:building_name) { |n| "testname#{n}"}
    sequence(:address) { |n| "testaddress#{n}"}
    sequence(:city) { |n| "testcity#{n}"}
    zipcode "93293"
    sequence(:state) { |n| "teststate#{n}"}
    user
  end

  factory :review do
    rating 4
    body "Test bodyyyy"
    user
    elevator
  end
end
