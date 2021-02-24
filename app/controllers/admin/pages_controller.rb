# app/controllers/admin/pages_controller.rb
class Admin::PagesController < ApplicationController
  before_action :require_admin
  before_action :set_users, :set_scenarios, only: :main
  before_action :set_scenario, :require_scenario_organisation, only: [:get_scenario, :get_attempts, :get_result]
  before_action :set_user, :require_user_organisation, only: [:get_attempts, :get_user, :set_admin, :approve_user, :get_result]
  before_action :set_attempts, only: :get_attempts
  before_action :set_attempt, only: :get_result

  # GET /admin
  def main
    render template: 'admin/main'
  end

  # PUT /admin/organisation?name=foo
  def update_organisation_name
    current_user.organisation.name = params[:name]

    respond_to do |format|
      format.html { render html: '', status: (current_user.organisation.save ? :ok : :bad_request)}
    end
  end

  # GET /admin/scenarios/:scenario_id
  def get_scenario
    render template: 'admin/scenarios'
  end

  # GET /admin/scenarios/:scenario_id/users/:user_id
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

  # GET /admin/scenarios/:scenario_id/users/:user_id/results/:result_id
  def get_result
    render template: 'admin/results'
  end

  private

  def require_scenario_organisation
    redirect_to root, error: 'You do not belong to this scenarios organisation!' unless current_user.organisation == @scenario.organisation
  end

  def require_user_organisation
    redirect_to root, error: 'This user does not belong to your organisation!' unless current_user.organisation == @user.organisation
  end

  def set_attempt
    @attempt = Attempt.find(params[:result_id])
  end

  def set_attempts
    @attempts = Attempt.all.where('user_id = ? and scenario_id = ?', @user, @scenario).order(:id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_users
    @users = User.all.where(organisation: current_user.organisation).order(:id)
  end

  def set_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end

  def set_scenarios
    @scenarios = current_user.organisation.scenarios.order(:id)
  end
end