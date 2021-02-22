# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_organisation_approval

  protected

  def configure_permitted_parameters
    added_attrs = %i[first_name last_name bio organisation_id email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def require_admin
    unless current_user.admin?
      respond_to do |format|
        format.html { redirect_to '/', notice: 'You are not an admin!' }
        format.json { json_response('', :forbidden) }
      end
    end
  end

  def require_organisation_approval
    if current_user.present? && !current_user.approved?
      respond_to do |format|
        format.html { render 'pages/approval' }
      end
    end
  end
end
