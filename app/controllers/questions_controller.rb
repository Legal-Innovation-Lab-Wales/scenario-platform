# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_question, except: %i[new create index]
  before_action :require_admin, only: %i[new create edit update delete]

  # GET /quizzes/:quiz_id/questions
  def index
    @questions = Question.all.where(quiz_id: @quiz.id)
    respond_to do |format|
      format.html
      # TODO: Improve this query
      format.json { json_response(@questions.as_json(include: :answers)) }
    end
  end

  # GET /quizzes/:quiz_id/questions/:id
  def show
    respond_to do |format|
      format.html
      # TODO: Improve this query
      format.json { json_response(@question.as_json(include: :answers)) }
    end
  end

  # GET /quizzes/:quiz_id/questions/new
  def new
    @question = Question.new
  end

  # POST /quizzes/:quiz_id/questions
  def create
    if (@question = current_user.questions.create!(question_params))
      respond_to do |format|
        format.html redirect_to(@quiz)
        format.json { json_response(@question, :created) }
      end
    else
      render @question.errors, status: :unprocessable_entity
    end
  end

  # GET /quizzes/:quiz_id/questions/:id/edit
  def edit
    @question
  end

  # PUT /quizzes/:quiz_id/questions/:id
  def update
    if @question.update(question_params)
      respond_to do |format|
        format.html redirect_to(@question)
        format.json { json_response(@question, status: :updated) }
      end
    else
      render @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/:quiz_id/questions/:id
  def destroy
    @question.destroy
  end

  private

  def set_quiz
    @quiz = if current_user.admin?
              Quiz.where(organisation: current_user.organisation).find(params[:quiz_id])
            else
              Quiz.where(organisation: current_user.organisation).where(available: true).find(params[:quiz_id])
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
