# app/controllers/answers_controller.rb
class AnswersController < ApplicationController
  before_action :set_question, :set_variables
  before_action :set_answer, only: %i[edit update destroy]
  before_action :require_admin

  # GET /quizzes/:quiz_id/questions/:question_id/answers/new
  def new
    @answer = Answer.new
  end

  # POST /quizzes/:quiz_id/questions/:question_id/answers
  def create
    if (@answer = current_user.answers.create!(answer_params.merge(question_id: @question.id)))
      respond_to do |format|
        format.html { redirect_to quiz_path(@question.quiz_id, anchor: "question_order_#{@question.order.to_s}") }
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
        format.html { redirect_to quiz_path(@question.quiz_id, anchor: "question_order_#{@question.order}") }
        format.json { json_response(@answer, :ok) }
      end
    else
      render @answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/:quiz_id/questions/:question_id/answers/:id
  def destroy
    if @answer.destroy
      respond_to do |format|
        format.html { redirect_to quiz_path(@question.quiz_id, anchor: "question_order_#{@question.order}") }
        format.json { json_response(nil, :no_content) }
      end
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_variables
    @variables = Quiz.find(params[:quiz_id]).variables
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    # whitelist params
    # variables = Quiz.find(params[:quiz_id]).variables.map { |v| [v.to_sym] }
    params.require(:answer).permit(:text, :next_question_order, :question_id, variable_mods: {})
  end
end
