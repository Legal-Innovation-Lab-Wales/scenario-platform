# app/models/quiz.rb
class Quiz < ApplicationRecord
  belongs_to :user
  delegate :organisation, to: :user, allow_nil: false

  has_many :questions, dependent: :destroy, foreign_key: :quiz_id
  has_many :quiz_attempts, foreign_key: :quiz_id

  scope :available, -> { where(available: true) }

  # validations
  validates_presence_of :user_id, :name, :description, :variables, :variable_initial_values, :variables_with_initial_values
end
