FactoryBot.define do
  factory :answer do
    question { nil }
    user { nil }
    text { "MyString" }
    variable_mods { "" }
    next_question_order { 1 }
    next_question_id { 1 }
  end
end
