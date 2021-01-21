# spec/models/question_spec.rb
require 'rails_helper'

RSpec.describe Question, type: :model do
  # Association Test
  # ensure Question record belongs to a single Quiz record
  it { should belong_to(:quiz) }
  # ensure Question record belongs to a single User
  it { should belong_to(:user) }
  # ensure Question model has a 1:m relationship with the Answer model
  it { should have_many(:answers).dependent(:destroy) }
end
