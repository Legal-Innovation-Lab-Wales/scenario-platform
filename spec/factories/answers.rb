# spec/factories/answers.rb
FactoryBot.define do
  factory :answer do
    question { create(:question) }
    user { create(:user) }
    text { 'MyString Try again' }
    variable_mods { '' }
    next_question_order { 1 }
  end
end
