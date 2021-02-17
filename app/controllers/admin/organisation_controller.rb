# app/controllers/admin/organisation_controller.rb
class Admin::OrganisationController < ApplicationController
  before_action :require_admin

  # PUT /admin/organisation?name=foo
  def update_name
    @organisation = Organisation.find_by(id: current_user.organisation)
    @organisation.name = params[:name]

    respond_to do |format|
      format.html { render html: '', status: (@organisation.save ? :ok : :bad_request)}
    end
  end
end