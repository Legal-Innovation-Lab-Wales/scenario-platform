# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def main
    if session[:awaiting_approval_notice].present?
      flash.now[:alert] = session[:awaiting_approval_notice]
      session.delete(:awaiting_approval_notice)
    end
    render template: 'pages/main'
  end

end
