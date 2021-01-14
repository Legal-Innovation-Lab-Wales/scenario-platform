class QuizzesController < ApplicationController

  def index
    @quizzes = if current_user.admin?
                 Quiz.where(organisation: current_user.organisation)
               else
                 Quiz.where(organisation: current_user.organisation).where(available: true)
               end

    respond_to do |format|
      format.html
      format.json { render json: @quizzes.as_json }
    end
  end

end
