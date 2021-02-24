# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Association Test
  # ensure User record belongs to a single Organisation
  it { should belong_to(:organisation) }
  # ensure User model has a 1:m relationship with the Scenario model
  it { should have_many(:scenarios) }
  # ensure User model has a 1:m relationship with the Question model
  it { should have_many(:questions) }
  # ensure User model has a 1:m relationship with the Answer model
  it { should have_many(:answers) }
  # ensure User model has a 1:m relationship with the Attempt model
  it { should have_many(:attempts) }

  # Validation Tests
  # ensure values are present before saving
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:organisation_id) }

end
