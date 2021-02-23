# app/controllers/admin/quizzes_controller.rb
class Admin::QuizzesController < ApplicationController
  before_action :require_admin, :set_quiz, :require_organisation, only: :get_quiz

  # GET /admin/quizzes/:id
  def get_quiz
    render template: 'admin/quizzes'
  end

  private

  def require_organisation
    if current_user.organisation != @quiz.organisation then redirect_to '/', notice: 'You do not belong to this organisation!' end
  end

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
end