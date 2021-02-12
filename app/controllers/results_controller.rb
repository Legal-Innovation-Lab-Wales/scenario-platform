class ResultsController < ApplicationController
  before_action :set_quiz_attempt, :verify_quiz_attempt, :verify_results, only: :show

  # GET /quizzes/:quiz_id/results/:quiz_attempt_id
  def show
    respond_to do |format|
      format.html
      format.json { json_response(@quiz_attempt, :ok) }
    end
  end

  private

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.where('user_id = ?', current_user.id).find(params[:quiz_attempt_id])
  end

  def verify_quiz_attempt
    unless @quiz_attempt.present?
      redirect_to quiz_path(params[:quiz_id])
    end
  end

  def verify_results
    unless @quiz_attempt.completed
      redirect_to quiz_question_path(@quiz_attempt.quiz_id, @quiz_attempt.next_question_id)
    end
  end
end