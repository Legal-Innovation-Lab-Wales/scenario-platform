# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :require_admin, :set_user, :require_organisation, :set_quizzes

  # GET /admin/users/:id
  def get_user
    render template: 'admin/user'
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

  def set_user
    @user = User.find(params[:id])
  end
end
