# app/models/attempt.rb
class Attempt < ApplicationRecord
  belongs_to :scenario
  belongs_to :user

  validates_presence_of :user_id, :scenario_id, :attempt_number

  def next_question_id
    if question_answers.length.positive?
      last_answer.next_question_id
    else
      scenario.first_question.id
    end
  end

  def last_answer
    Answer.find(question_answers.last['answer_id'])
  end

  def been_answered?(question_id)
    question_answers.any? { |answer| answer['question_id'] == question_id }
  end

  def slice_question_answers(question_id)
    update(question_answers: question_answers.slice(0, question_answers.index { |answer| answer['question_id'] == question_id }))
  end

  def completed
    scores.present?
  end
end
