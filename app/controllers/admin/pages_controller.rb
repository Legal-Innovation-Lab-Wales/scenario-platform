# app/controllers/admin/pages_controller.rb
class Admin::PagesController < ApplicationController
  before_action :require_admin
  before_action :set_users, :set_organisation, only: :main

  # GET /admin
  def main
    render template: 'admin/main'
  end

  private

  def set_users
    @users = User.all.where(organisation: current_user.organisation)
  end

  def set_organisation
    @organisation = current_user.organisation
  end
end