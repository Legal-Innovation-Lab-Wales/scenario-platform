# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :require_admin

  # GET /admin/users
  def index
    @users = User.all.where(organisation: current_user.organisation)
    render template: 'admin/users'
  end

  private

  def account_update_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :admin)
  end
end
