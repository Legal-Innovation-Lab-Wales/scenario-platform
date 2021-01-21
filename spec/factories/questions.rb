# spec/factories/questions.rb
FactoryBot.define do
  factory :question do
    quiz { create(:quiz) }
    user { create(:user) }
    sequence(:order)
    text { 'MyString' }
    description { 'MyString' }
  end
end
