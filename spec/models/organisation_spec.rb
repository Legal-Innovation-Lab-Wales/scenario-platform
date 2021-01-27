# spec/models/organisation_spec.rb
require 'rails_helper'

RSpec.describe Organisation, type: :model do
  it { should have_many(:users) }
  it { should have_many(:quizzes).through(:users) }
end
