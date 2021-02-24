# app/models/scenario.rb
class Scenario < ApplicationRecord
  belongs_to :user
  delegate :organisation, to: :user, allow_nil: false

  has_many :questions, dependent: :destroy, foreign_key: :scenario_id
  has_many :attempts, foreign_key: :scenario_id
  has_many :users, -> { distinct }, through: :attempts

  scope :available, -> { where(available: true) }

  # validations
  validates_presence_of :user_id, :name, :description, :variables, :variable_initial_values, :variables_with_initial_values

  def first_question
    questions.find_by(order: 0)
  end
end
