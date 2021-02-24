# spec/models/answer_spec.rb
require 'rails_helper'

RSpec.describe Scenario, type: :model do
  # Association Test
  # ensure Scenario record belongs to a single User
  it { should belong_to(:user) }
  # ensure Scenario model has a 1:m relationship with the Question model
  it { should have_many(:questions).dependent(:destroy) }
  # ensure Scenario model has a 1:m relationship with the Attempt model
  it { should have_many(:attempts) }
  # ensure scenario response to organisation
  it { should respond_to(:organisation) }

  # Validation Tests
  # ensure values are present before saving
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:variables) }
  it { should validate_presence_of(:variable_initial_values) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
end
