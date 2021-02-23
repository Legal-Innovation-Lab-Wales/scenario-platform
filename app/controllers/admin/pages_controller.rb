# app/controllers/admin/pages_controller.rb
class Admin::PagesController < ApplicationController
  before_action :require_admin, :set_organisation
  before_action :set_users, :set_quizzes, only: :main
  before_action :set_quiz, :require_quiz_organisation, only: [:get_quiz, :get_attempts, :get_result]
  before_action :set_user, :require_user_organisation, only: [:get_attempts, :get_user, :set_admin, :approve_user, :get_result]
  before_action :set_attempts, only: :get_attempts
  before_action :set_attempt, only: :get_result

  # GET /admin
  def main
    render template: 'admin/main'
  end

  # PUT /admin/organisation?name=foo
  def update_organisation_name
    @organisation.name = params[:name]

    respond_to do |format|
      format.html { render html: '', status: (@organisation.save ? :ok : :bad_request)}
    end
  end

  # GET /admin/quizzes/:quiz_id
  def get_quiz
    render template: 'admin/quizzes'
  end

  # GET /admin/quizzes/:quiz_id/users/:user_id
  def get_attempts
    render template: 'admin/attempts'
  end

  # GET /admin/users/:id
  def get_user
    render template: 'admin/user'
  end

  # PUT /admin/users/:id/approve
  def approve_user
    respond_to do |format|
      format.html { render html: '', status: (@user.update(approved: true) ? :ok : :bad_request)}
    end
  end

  # PUT /admin/users/:id/admin
  def set_admin
    respond_to do |format|
      format.html { render html: '', status: (@user.update(admin: !@user.admin) ? :ok : :bad_request)}
    end
  end

  # GET /admin/quizzes/:quiz_id/users/:user_id/results/:result_id
  def get_result
    render template: 'admin/results'
  end

  private

  def require_quiz_organisation
    redirect_to root, notice: 'You do not belong to this quizzes organisation!' unless @organisation == @quiz.organisation
  end


  def require_user_organisation
    redirect_to root, notice: 'This user does not belong to your organisation!' unless @organisation == @user.organisation
  end

  def set_attempt
    @attempt = QuizAttempt.find(params[:result_id])
  end

  def set_attempts
    @attempts = QuizAttempt.all.where('user_id = ? and quiz_id = ?', @user, @quiz).order(:id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_users
    @users = User.all.where(organisation: current_user.organisation).order(:id)
  end

  def set_organisation
    @organisation = current_user.organisation
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_quizzes
    @quizzes = @organisation.quizzes.order(:id)
  end
end