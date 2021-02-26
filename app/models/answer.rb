# app/models/answer.rb
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  before_create :update_next_question_id
  before_update :update_next_question_id

  def update_variable_mods
    question.scenario.variables.each { |variable| self.variable_mods.store(variable, 0) unless self.variable_mods.include? variable }
    self.variable_mods.each { |key, value| self.variable_mods.delete(key) unless question.scenario.variables.include? key }
    self.save
  end

  private

  def update_next_question_id
    return unless next_question_order? && next_question_order != -1

    self.next_question_id = question.scenario.questions.find_by!(order: next_question_order).id
  end

  # validations
  validates_presence_of :text, :user_id, :question_id
  validate :valid_variable_mods

  def valid_variable_mods
    return true if variable_mods.blank?

    valid_variables = Scenario.find(Question.find(question_id).scenario_id).variables
    invalid_keys = variable_mods.keys - valid_variables

    return if variable_mods.keys.all? { |s| valid_variables.include? s }

    errors.add(invalid_keys.to_s, 'are not valid variables')
  end
end
