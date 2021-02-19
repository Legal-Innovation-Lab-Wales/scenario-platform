# app/controllers/admin/pages_controller.rb
class Admin::PagesController < ApplicationController
  before_action :require_admin
  before_action :set_approved_users, :set_unapproved_users, :set_organisation, only: :main

  # GET /admin
  def main
    render template: 'admin/main'
  end

  private

  def set_unapproved_users
    @unapproved_users = User.all.where(organisation: current_user.organisation, approved: false).order(:id)
  end

  def set_approved_users
    @approved_users = User.all.where(organisation: current_user.organisation, approved: true).order(:id)
  end

  def set_organisation
    @organisation = current_user.organisation
  end
end