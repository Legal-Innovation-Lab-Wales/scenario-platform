# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:main, :terms]

  def main
    render template: 'pages/main'
  end

  def terms
    render template: 'pages/terms'
  end
end
