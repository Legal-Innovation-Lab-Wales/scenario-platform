# app/controllers/admin/attempts_controller.rb
class Admin::AttemptsController < ApplicationController
  before_action :require_admin, :set_quiz, :require_organisation, :set_user, :set_attempts

  # GET /admin/quizzes/:quiz_id/users/:user_id
  def get_attempts
    render template: 'admin/attempts'
  end

  private

  def require_organisation
    if current_user.organisation != @quiz.organisation then redirect_to '/', notice: 'You do not belong to this organisation!' end
  end

  def set_attempts
    @attempts = QuizAttempt.all.where('user_id = ? and quiz_id = ?', @user, @quiz).order(:id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end