# spec/models/answer_spec.rb
require 'rails_helper'

RSpec.describe Answer, type: :model do
  # Association Test
  # ensure Answer record belongs to a single Question record
  it { should belong_to(:question) }
  # Validation Tes
  # ensure values are present before saving
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:question_id) }
end
