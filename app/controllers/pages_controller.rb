# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:main]

  def main
    render template: 'pages/main'
  end

end
