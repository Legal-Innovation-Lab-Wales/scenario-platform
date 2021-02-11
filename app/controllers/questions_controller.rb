# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_question, except: %i[new create index]
  before_action :set_quiz_attempt, only: :show
  before_action :verify_quiz_attempt, only: :show
  before_action :require_admin, except: :show

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
    if (@question = current_user.questions.create!(question_params.merge(quiz_id: @quiz.id)))
      respond_to do |format|
        format.html { redirect_to quiz_path(@question.quiz_id, anchor: "question_order_#{@question.order}") }
        format.json { json_response(@question.as_json, :created) }
      end
    else
      respond_to do |format|
        format.html { render 'new' } # when new exists render new
        format.json { json_response(@question.errors) }
      end
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
        format.html { redirect_to quiz_path(@question.quiz_id, anchor: "question_order_#{@question.order}") }
        format.json { json_response(@question, :no_content) }
      end
    else
      respond_to do |format|
        format.html { render 'edit' } # when new exists render new
        format.json { json_response(@question.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /quizzes/:quiz_id/questions/:id
  def destroy
    if @question.destroy
      respond_to do |format|
        format.html { redirect_to quiz_path(@question.quiz_id) }
        format.json { json_response(@question, :no_content) }
      end
    end
  end

  private

  def verify_quiz_attempt
    if @quiz_attempt.nil? || @quiz_attempt.completed
      redirect_to quiz_path(@quiz.id)
    elsif @question.id != @quiz_attempt.next_question_id && !@quiz_attempt.has_been_answered(@question.id)
      redirect_to quiz_question_path(@quiz.id, @quiz_attempt.next_question_id)
    end
  end

  def set_quiz
    @quiz = if current_user.admin?
              current_user.organisation.quizzes.find(params[:quiz_id])
            else
              current_user.organisation.quizzes.available.find(params[:quiz_id])
            end
  end

  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.find(session["quiz_id_#{@quiz.id}"])
  end

  def question_params
    # whitelist params
    params.require(:question).permit(:order, :text, :description, :quiz_id)
  end

end
