# spec/factories/answers.rb
FactoryBot.define do
  factory :answer do
    question { create(:question) }
    user { create(:user) }
    text { 'MyString Answer Factory' }
    variable_mods { '' }
  end

  trait :with_next_question_order do
    next_question_order { 1 }
  end
end
