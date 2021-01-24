# spec/factories/quizzes.rb
FactoryBot.define do
  factory :quiz do
    user { create(:user, :admin) }
    name { 'Quiz Factory Name' }
    description { 'MyText' }
    variables { ['health', 'stamina', 'experience', 'coin'] }
    variable_initial_values { [100, 100, 0, 10] }
    available { true }
    organisation { 'One' }
  end

  trait :unavailable do
    available { false }
  end

  trait :without_organisation do
    organisation {}
  end
end
