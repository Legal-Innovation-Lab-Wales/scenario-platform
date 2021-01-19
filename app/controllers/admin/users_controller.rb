class Admin::UsersController < ApplicationController
  before_action :authorize_admin
  before_action :set_user, except: :index

  def index
    render template: "admin/users"
  end

  def authorize_admin
    redirect_to(root_path) unless current_user && current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end