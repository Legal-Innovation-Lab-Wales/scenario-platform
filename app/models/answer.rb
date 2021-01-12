class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  before_create :update_next_question_id
  before_update :update_next_question_id

  private

  def update_next_question_id
    # TODO Guard this - if next_question_order doesn't exist
    self.next_question_ID = question.quiz.questions.find_by(order: next_question_order).id if next_question_order != -1
  end

end
