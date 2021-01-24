module Admin
  class UsersController < ApplicationController
    before_action :authorize_admin
    # before_action :set_user, except: :index

    def index
      @users = User.all.where(organisation: current_user.organisation)
      render template: 'admin/users'
    end

    private

    def authorize_admin
      redirect_to(root_path) unless current_user.admin?
    end

    # def set_user
    #   @user = User.find(params[:id])
    # end

    def account_update_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :email,
                                   :admin)
    end
  end
end
