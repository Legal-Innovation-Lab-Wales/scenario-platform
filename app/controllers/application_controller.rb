# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = %i[first_name last_name bio organisation_id email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def require_admin
    unless current_user.admin?
      respond_to do |format|
        format.html { redirect_to root }
        format.json { json_response('', :forbidden) }
      end
    end
  end
end
