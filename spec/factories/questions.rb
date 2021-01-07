FactoryBot.define do
  factory :question do
    quiz { nil }
    user { nil }
    order { 1 }
    text { "MyString" }
    description { "MyString" }
  end
end
