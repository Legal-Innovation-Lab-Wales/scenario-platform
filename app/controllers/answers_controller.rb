# app/controllers/answers_controller.rb
class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :require_admin

  # GET /quizzes/:quiz_id/questions/:question_id/answers/new
  def new
    @answer = Answer.new
  end

  # POST /quizzes/:quiz_id/questions/:question_id/answers
  def create
    if (@answer = current_user.answers.create!(answer_params))
      respond_to do |format|
        format.html redirect_to(@question)
        format.json { json_response(@answer, :created) }
      end
    else
      render @answer.errors, status: :unprocessable_entity
    end
  end

  # GET /quizzes/:quiz_id/questions/:question_id/answers/:id
  def edit
    @answer
  end

  # PUT /quizzes/:quiz_id/questions/:question_id/answers/:id
  def update
    if @answer.update(answer_params)
      respond_to do |format|
        format.html redirect_to(@question)
        format.json { json_response(@answer, :updated) }
      end
    else
      render @answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/:quiz_id/questions/:question_id/answers/:id
  def destroy
    @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    # whitelist params
    params.require(:answer).permit(:text, :variable_mods, :next_question_order)
  end
end
