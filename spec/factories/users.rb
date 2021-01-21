# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { 'test@test.com' }
    password { 'test1234' }
    organisation { 'One' }
    first_name { 'Test' }
    last_name { 'Test' }

    trait :admin do
      admin { true }
    end
  end

end
