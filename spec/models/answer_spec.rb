# spec/models/answer_spec.rb
require 'rails_helper'

RSpec.describe Answer, type: :model do
  # Association Test
  # ensure Answer record belongs to a single Question
  it { should belong_to(:question) }
  # ensure Answer record belongs to a single User
  it { should belong_to(:user) }

  # Validation Tests
  # ensure values are present before saving
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:question_id) }

  context 'when creating an answer' do
    let(:answer) { create(:answer) }

    it 'updates the next question id' do
      expect answer.next_question_id.present?
    end
  end
end
