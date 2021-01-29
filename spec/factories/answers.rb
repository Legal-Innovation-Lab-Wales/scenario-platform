# spec/factories/answers.rb
FactoryBot.define do
  factory :answer do
    question { create(:question) }
    user { create(:user) }
    text { 'MyString Answer Factory' }
    variable_mods { '' }
  end

  trait :with_next_question_order do
    question { Question.first || association(:question) }
    next_question_order { Question.second.present? ? Question.second.order : question.order }
  end
end
