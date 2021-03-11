# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :organisation, only: %i[new create]
  after_action :send_new_user_email, only: :create

  private

  def organisation
    @organisations = Organisation.all.map { |organisation| [organisation.name, organisation.id] }.to_h
  end

  def send_new_user_email
    return unless @user.created_at? || Time.now - User.second_to_last.created_at < 6.hours

    unapproved_users_count = @user.organisation.unapproved_users.count
    @user.organisation.admins.each do |admin|
      AdminMailer.with(user: @user, admin: admin, unapproved_users: unapproved_users_count).new_user_email.deliver_later
    end
  end
end
