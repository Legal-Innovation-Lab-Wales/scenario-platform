class QuestionsController < ApplicationController

  before_action :set_question, only: [:show]

  def show
    @question



    respond_to do |format|
      format.html
      # TODO Improve this query
      format.json { render json: @question.as_json(include: :answers), status: :ok }
    end

  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

end
