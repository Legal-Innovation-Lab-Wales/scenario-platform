# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  before_action :set_quiz
  before_action :set_quiz_attempt, only: :show
  before_action :set_question, except: %i[new create index]
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
    # User has not started an attempt for this quiz
    if @quiz_attempt.nil?
      redirect_to quiz_path(@quiz.id)
    else
      # User has started and attempt and answered questions
      if @quiz_attempt.question_answers.length > 0
        $next_question = helpers.next_question(@quiz_attempt)

        # Fetch this question if it is the expected next question or it is a question that has previously been answered./
        if @question.id == $next_question.id or helpers.match_question(@quiz_attempt, @question.id)
          get_question
        else
          # User has jumped to around to unexpected question given the attempt
          redirect_question($next_question.id)
        end
      else
        # User has started an attempt but not answered any questions => they should be at first question
        if @question.order == 0 then get_question else redirect_question(@quiz.questions.find_by(order: 0)) end
      end
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

  def get_question
    respond_to do |format|
      format.html
      # TODO: Improve this query
      format.json { json_response(@question.as_json(include: :answers)) }
    end
  end

  def redirect_question(question_id)
    redirect_to quiz_question_path(@quiz.id, question_id)
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
    @quiz_attempt = helpers.quiz_attempt(current_user.id, @quiz.id)
  end

  def question_params
    # whitelist params
    params.require(:question).permit(:order, :text, :description, :quiz_id)
  end

end
