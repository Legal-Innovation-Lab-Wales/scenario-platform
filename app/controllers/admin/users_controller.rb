# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user

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

  # GET /admin/users/:id/scores
  def scores
    @quiz_attempts = QuizAttempt.all.where(user_id: @user)
    render template: 'admin/user'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
