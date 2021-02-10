module ApplicationHelper
  def quiz_attempt(user_id, quiz_id)
    QuizAttempt.where('user_id = ? and quiz_id = ? and active = true', user_id, quiz_id).order(:attempt_number).last
  end

  def has_question(quiz_attempt, question_id)
    quiz_attempt.question_answers.any? { |answer| answer['question_id'] == question_id }
  end

  def next_question(quiz_attempt)
    Question.find(Answer.find(quiz_attempt.question_answers.last['answer_id']).next_question_id)
  end

  def has_answers(quiz_attempt)
    quiz_attempt.question_answers.length > 0
  end

  def first(quiz)
    quiz.questions.find_by(order: 0)
  end
end
