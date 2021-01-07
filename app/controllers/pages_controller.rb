class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:main, :about]
  before_action :set_user, only: :user_profile

  def main
  end

  def about
  end

  def user_profile
  end
end
