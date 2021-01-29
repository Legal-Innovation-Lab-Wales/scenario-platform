# spec/factories/questions.rb
FactoryBot.define do
  factory :question do
    quiz { Quiz.first || association(:quiz) }
    user { quiz.user || association(:user) }
    sequence(:order)
    text { 'MyString' }
    description { 'MyString' }
  end
end
