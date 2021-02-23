class DeviseCustomMailer < Devise::Mailer
  helper :application
  default template_path: 'devise/mailer'
  layout 'mailer'

  def confirmation_instructions(record, token, opts={})
    super
  end
end