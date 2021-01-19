# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_question
  before_action :require_admin, only: [:new, :create, :edit, :update]

  # GET /quizzes/:id/questions/:id
  def show
    @question

    respond_to do |format|
      format.html
      # TODO Improve this query
      format.json { render json: @question.as_json(include: :answers), status: :ok }
    end
  end

  # GET /quizzes/:id/questions/new
  def new
    @quiz = Quiz.new
  end

  # POST /quizzes/:id/questions
  def create
    if (@question = current_user.questions.create!(question_params))
      respond_to do |format|
        format.html redirect_to(@quiz)
        format.json { json_response(@question, :created) }
      end
    else
      render @quiz.errors, status: :unprocessable_entity
    end
  end

  # GET /quizzes/:id/questions/:id/edit
  def edit
    @question
  end

  # PUT /quizzes/:id/questions/:id
  def update
    if @question.update(question_params)
      respond_to do |format|
        format.html redirect_to(@question)
        format.json { json_response(@question, :updated) }
      end
    else
      render @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/:id/questions/:id
  def destroy
    @question.destroy
  end

  private

  def set_quiz
    @quiz = if current_user.admin?
              Quiz.where(organisation: current_user.organisation).find(params[:id])
            else
              Quiz.where(organisation: current_user.organisation).where(available: true).find(params[:id])
            end
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def require_admin
    redirect_to root unless current_user.admin?
  end

  def question_params
    # whitelist params
    params.require(:question).permit(:order, :text, :description)
  end

end
