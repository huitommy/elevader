require 'factory_girl'

FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    sequence(:password) { |n| "password#{n}" }
  end

end
