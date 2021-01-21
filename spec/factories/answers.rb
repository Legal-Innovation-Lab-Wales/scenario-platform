# spec/factories/answers.rb
FactoryBot.define do
  factory :answer do
    question { 1 }
    user { 1 }
    text { 'MyString Try again' }
    variable_mods { '' }
    next_question_order { 1 }
    next_question_id { 1 }
  end
end
