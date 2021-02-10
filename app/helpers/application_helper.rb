module ApplicationHelper
  def quiz_attempt(user_id, quiz_id)
    QuizAttempt.where('user_id = ? and quiz_id = ? and scores is null', user_id, quiz_id).order(:attempt_number).last
  end

  def match_question(quiz_attempt, question_id)
    quiz_attempt.question_answers.any? { |answer| answer['question_id'] == question_id }
  end
end
