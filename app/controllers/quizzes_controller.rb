# app/controllers/quizzes_controller.rb
class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show update destroy]
  before_action :require_admin, only: %i[new create edit update delete]
  before_action :create_variables_hstore, only: %i[create update]

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
    if (@quiz = current_user.quizzes.create!(quiz_params.merge(variables_with_initial_values: create_variables_hstore)))
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
    if @quiz.update(quiz_params.merge(variables_with_initial_values: create_variables_hstore))
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
    if @quiz.destroy
      respond_to do |format|
        format.html { redirect_to quizzes_path }
        format.json { json_response(@quiz, :no_content) }
      end
    end
  end

  private

  def set_quiz
    @quiz = if current_user.admin?
              current_user.organisation.quizzes.find(params[:id])
            else
              current_user.organisation.quizzes.available.find(params[:id])
            end
  end

  def create_variables_hstore
    vars = params['quiz']['variables']
    vals = params['quiz']['variable_initial_values']
    vars.zip(vals).to_h
  end

  def quiz_params
    # whitelist params
    params.require(:quiz).permit(:name, :description, :available, { variables: [] }, { variable_initial_values: [] }, variables_with_initial_values: {})
  end
end
