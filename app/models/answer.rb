# app/models/answer.rb
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  before_create :update_next_question_id
  before_update :update_next_question_id

  private

  def update_next_question_id
    self.next_question_id = question.quiz.questions.find_by(order: next_question_order).id if (next_question_order? && next_question_order != -1)
  end

  # validations
  validates_presence_of :text, :user_id, :question_id

end
