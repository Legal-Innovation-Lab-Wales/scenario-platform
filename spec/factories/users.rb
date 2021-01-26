# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    organisation { create(:organisation) }
    email { Faker::Internet.email }
    password { 'test1234' }
    password_confirmation { 'test1234' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Date.today }

    trait :admin do
      admin { true }
    end
  end

end
