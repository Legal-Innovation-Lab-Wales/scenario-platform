# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  default template_path: 'admin/mailer'

  def new_user_email
    @user = params[:user]
    @admin = params[:admin]
    @unapproved_users_count = params[:unapproved_users]
    mail(to: @admin.email, subject: 'New User on Scenario Platform')
  end
end
