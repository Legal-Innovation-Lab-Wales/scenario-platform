# app/controllers/admin/results_controller.rb
class Admin::ResultsController < ApplicationController
  before_action :require_admin, :set_quiz, :require_organisation, :set_user, :set_attempt

  # GET /admin/quizzes/:quiz_id/users/:user_id/results/:id
  def get_result
    render template: 'admin/results'
  end

  private

  def require_organisation
    if current_user.organisation != @quiz.organisation then redirect_to '/', notice: 'You do not belong to this organisation!' end
  end

  def set_attempt
    @attempt = QuizAttempt.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end