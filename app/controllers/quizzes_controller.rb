# app/controllers/quizzes_controller.rb
class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :update]
  before_action :require_admin, only: [:new, :create, :edit, :update]

  # GET /quizzes
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

  # GET /quizzes/:id
  def show
    @quiz
    respond_to do |format|
      format.html
      # TODO Improve this query
      # format.json { render json: @quiz.as_json }
      format.json { render json: @quiz.as_json(include: { questions: { include: :answers } }), status: :ok }
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
        format.html redirect_to(@quiz)
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
      render json: @quiz
    else
      render @quiz.errors, status: :unprocessable_entity
    end
  end

  private

  def set_quiz
    @quiz = if current_user.admin?
              Quiz.where(organisation: current_user.organisation).find(params[:id])
            else
              Quiz.where(organisation: current_user.organisation).where(available: true).find(params[:id])
            end
  end

  def require_admin
    redirect_to index unless current_user.admin?
  end

  def quiz_params
    # whitelist params
    params.require(:quiz).permit(:variables, :variable_initial_values, :name, :available, :description)
  end
end
