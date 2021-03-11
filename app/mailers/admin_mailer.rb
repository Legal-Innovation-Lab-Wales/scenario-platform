# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  default template_path: 'admin/mailer'

  def new_user_email
    @user = params[:user]
    @user.organisation.admins.each do |admin|
      mail(to: admin.email, subject: 'New User on Scenario Platform')
    end
  end

end
