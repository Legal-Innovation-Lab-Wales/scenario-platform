# app/controllers/admin/pages_controller.rb
class Admin::PagesController < ApplicationController
  before_action :require_admin
  before_action :set_users, :set_organisation, :set_quizzes, only: :main

  # GET /admin
  def main
    render template: 'admin/main'
  end

  private

  def set_users
    @users = User.all.where(organisation: current_user.organisation).order(:id)
  end

  def set_organisation
    @organisation = current_user.organisation
  end

  def set_quizzes
    @quizzes = @organisation.quizzes.order(:id)
  end
end