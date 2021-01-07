FactoryBot.define do
  factory :quiz_attempt do
    quiz { nil }
    user { nil }
    attempt_number { 1 }
    question_answers { "" }
    scores { 1 }
  end
end
