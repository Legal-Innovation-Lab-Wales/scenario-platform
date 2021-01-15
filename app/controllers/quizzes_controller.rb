class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show]
  before_action :require_admin, only: [:new, :create, :edit, :update]

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

  def show
    @quiz

    respond_to do |format|
      format.html
      # TODO Improve this query
      # format.json { render json: @quiz.as_json }
      format.json { render json: @quiz.as_json(include: { questions: { include: :answers } }), status: :ok }
    end
  end

  def new
    @quiz = Quiz.new
  end

  def create
    if (@quiz = current_user.quizzes.create!(quiz_params))
      respond_to do |format|
        format.html redirect_to(@quiz)
        format.json { render json: @quiz.as_json }
      end
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update

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
    #whitelist params
    params.require(:quiz).permit(:variables, :variable_initial_values, :name, :available, :description)
  end

end
