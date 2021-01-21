# spec/factories/questions.rb
FactoryBot.define do
  factory :question do
    quiz { create(:quiz) }
    user { create(:user) }
    order { 1 }
    text { 'MyString' }
    description { 'MyString' }
  end
end
