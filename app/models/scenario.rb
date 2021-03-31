# app/models/scenario.rb
class Scenario < ApplicationRecord
  belongs_to :user
  delegate :organisation, to: :user, allow_nil: false

  has_many :questions, dependent: :destroy, foreign_key: :scenario_id
  has_many :answers, through: :questions
  has_many :attempts, foreign_key: :scenario_id
  has_many :users, -> { distinct }, through: :attempts

  scope :available, -> { where(available: true) }

  after_update :update_answers

  # validations
  validates_presence_of :user_id, :name, :description

  def first_question
    questions.find_by(order: 0)
  end

  private

  def update_answers
    return unless answers.present?

    answers.each(&:update_variable_mods)
  end
end
