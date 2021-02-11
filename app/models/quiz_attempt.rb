class QuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user

  validates_presence_of :user_id, :quiz_id, :attempt_number

  def next_question_id
    if self.question_answers.length > 0
      Question.find(self.last_answer.next_question_id).id
    else
      Quiz.find(self.quiz_id).first_question.id
    end
  end

  def last_answer
    Answer.find(self.question_answers.last['answer_id'])
  end

  def has_been_answered(question_id)
    self.question_answers.any? { |answer| answer['question_id'] == question_id }
  end

  def slice_question_answers(question_id)
    self.update(question_answers: self.question_answers.slice(0, self.question_answers.index { |answer| answer['question_id'] == question_id }))
  end

  def completed
    !self.scores.nil?
  end
end
