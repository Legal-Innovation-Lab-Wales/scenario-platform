# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :require_admin, :set_user, :require_organisation
  before_action :set_quizzes, only: :get_user

  # GET /admin/users/:id
  def get_user
    render template: 'admin/user'
  end

  # PUT /admin/users/:id/approve
  def approve
    respond_to do |format|
      format.html { render html: '', status: (@user.update(approved: true) ? :ok : :bad_request)}
    end
  end

  # PUT /admin/users/:id/admin
  def admin
    respond_to do |format|
      format.html { render html: '', status: (@user.update(admin: !@user.admin) ? :ok : :bad_request)}
    end
  end

  private

  def require_organisation
    if current_user.organisation != @user.organisation then redirect_to '/', notice: 'You do not belong to this organisation!' end
  end

  def set_quizzes
    @quizzes = []
    QuizAttempt.all.where(user_id: @user).each do |attempt|
      quiz = @quizzes.find { |i| i[:id] == attempt.quiz.id }

      if quiz.nil?
        @quizzes << { id: attempt.quiz.id, name: attempt.quiz.name, count: 1 }
      else
        quiz[:count] = quiz[:count] + 1
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end
end
