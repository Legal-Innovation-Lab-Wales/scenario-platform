# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :organisation, only: %i[new create]
  after_action :send_new_member_email, only: :create

  private

  def organisation
    @organisations = Organisation.all.map { |organisation| [organisation.name, organisation.id] }.to_h
  end

  def send_new_member_email
    return unless @user.created_at?

    AdminMailer.with(user: @user).new_user_email.deliver_later
  end
end
