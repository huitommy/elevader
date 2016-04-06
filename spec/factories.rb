require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    password "password"
  end

  factory :elevator do
    sequence(:building_name) { |n| "testname#{n}"}
    sequence(:address) { |n| "testaddress#{n}"}
    sequence(:city) { |n| "testcity#{n}"}
    sequence(:zipcode) { |n| "9329#{n}"}
    sequence(:state) { |n| "teststate#{n}"}
    user
  end

  factory :review do
    rating 4
    body "Test bodyyyy"
    user
    elevator
  end

  factory :admin do
    sequence(:email) { |n| "admin#{n}@admins.com" }
    password "password"
  end
end