# spec/factories/questions.rb
FactoryBot.define do
  factory :question do
    scenario { Scenario.first || association(:scenario) }
    user { scenario.user || association(:user) }
    sequence(:order)
    text { 'MyString' }
    description { 'MyString' }
  end
end
