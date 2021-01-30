# app/controllers/quizzes_controller.rb
class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show update destroy]
  before_action :require_admin, only: %i[new create edit update delete]

  # GET /quizzes
  def index
    @quizzes = if current_user.admin?
                 current_user.organisation.quizzes
               else
                 current_user.organisation.quizzes.available
               end

    respond_to do |format|
      format.html
      format.json { json_response(@quizzes) }
    end
  end

  # GET /quizzes/:id
  def show
    quiz = if current_user.admin?
             @quiz.as_json(include: { questions: { include: :answers } })
           else
             @quiz
           end
    respond_to do |format|
      format.html
      format.json { json_response(quiz) }
    end
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # POST /quizzes
  def create
    if (@quiz = current_user.quizzes.create!(quiz_params))
      respond_to do |format|
        format.html { redirect_to(@quiz) }
        format.json { json_response(@quiz, :created) }
      end
    else
      render @quiz.errors, status: :unprocessable_entity
    end
  end

  # GET /quizzes/:id/edit
  def edit
    @quiz = Quiz.find(params[:id])
  end

  # PUT /quizzes/:id
  def update
    if @quiz.update(quiz_params)
      respond_to do |format|
        format.html { redirect_to(@quiz) }
        format.json { json_response(@quiz, :no_content) }
      end
    else
      render @quiz.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/:quiz_id
  def destroy
    @quiz.destroy
  end

  private

  def set_quiz
    @quiz = if current_user.admin?
              current_user.organisation.quizzes.find(params[:id])
            else
              current_user.organisation.quizzes.available.find(params[:id])
            end
  end

  def quiz_params
    # whitelist params
    params.require(:quiz).permit(:name, :description, :available, { variables: [] }, { variable_initial_values: [] })
  end
end
