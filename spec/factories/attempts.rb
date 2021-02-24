# spec/factories/attempts.rb
FactoryBot.define do
  factory :attempt do
    scenario { nil }
    user { nil }
    attempt_number { 1 }
    question_answers { "" }
    scores { 1 }
  end
end
