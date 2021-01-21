# spec/factories/quizzes.rb
FactoryBot.define do
  factory :quiz do
    user { create(:user) }
    name { 'MyString' }
    description { 'MyText' }
    variables { ['health', 'stamina', 'experience', 'coin'] }
    variable_initial_values { [100, 100, 0, 10] }
    available { true }
    organisation { 'One' }
  end
end
