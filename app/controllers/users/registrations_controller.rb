# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :organisation, only: [:new, :create]

  def organisation
    @organisations = Organisation.all.map{ |organisation| [organisation.name, organisation.id] }.to_h
  end
end
