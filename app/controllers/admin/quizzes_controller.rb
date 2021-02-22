# app/controllers/admin/quizzes_controller.rb
class Admin::QuizzesController < ApplicationController
  before_action :require_admin, :set_quiz, :require_organisation, :set_users, only: :get_quiz

  # GET /admin/quizzes/:id
  def get_quiz
    render template: 'admin/quizzes'
  end

  private

  def require_organisation
    if current_user.organisation != @quiz.organisation then redirect_to '/', notice: 'You do not belong to this organisation!' end
  end

  def set_users
    @users = []
    QuizAttempt.all.where(quiz_id: @quiz).each do |attempt|
      user = @users.find { |i| i[:id] == attempt.user.id }

      if user.nil?
        @users << { id: attempt.user.id, first_name: attempt.user.first_name, last_name: attempt.user.last_name, email: attempt.user.email, count: 1 }
      else
        user[:count] = user[:count] + 1
      end
    end
  end

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
end