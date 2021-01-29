# app/models/answer.rb
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  before_create :update_next_question_id
  before_update :update_next_question_id

  private

  def update_next_question_id
    if next_question_order? && next_question_order != -1
      self.next_question_id = question.quiz.questions.find_by!(order: next_question_order).id
    end
  end

  # validations
  validates_presence_of :text, :user_id, :question_id
  validate :valid_variable_mods

  def valid_variable_mods
    return true if variable_mods.blank?

    valid_variables = Quiz.find(Question.find(question_id).quiz_id).variables
    invalid_keys = variable_mods.keys - valid_variables

    return if variable_mods.keys.all? { |s| valid_variables.include? s }

    errors.add(invalid_keys.to_s, 'are not valid variables')
  end
end
