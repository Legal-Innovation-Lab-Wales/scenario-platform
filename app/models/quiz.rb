class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy, foreign_key: :quiz_id
  has_many :quiz_attempts, foreign_key: :quiz_id

  before_create :add_org_to_quiz

  private

  def add_org_to_quiz
    self.organisation = user.organisation
  end

  # validations
  validates_presence_of :user_id, :organisation, :variables, :variable_initial_values, :name, :description

end
