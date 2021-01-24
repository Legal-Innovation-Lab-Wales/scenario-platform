# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Association Test
  # ensure User model has a 1:m relationship with the Quiz model
  it { should have_many(:quizzes) }
  # ensure User model has a 1:m relationship with the Question model
  it { should have_many(:questions) }
  # ensure User model has a 1:m relationship with the Answer model
  it { should have_many(:answers) }
  # ensure User model has a 1:m relationship with the Quiz_attempt model
  it { should have_many(:quiz_attempts) }

  # Validation Tests
  # ensure values are present before saving
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:organisation) }

end
