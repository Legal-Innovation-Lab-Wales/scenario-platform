FactoryBot.define do
  factory :question do
    quiz { 1 }
    user { 1 }
    order { 1 }
    text { "MyString" }
    description { "MyString" }
  end
end
