class QuizAttemptsController < ApplicationController
  before_action :set_answer, only: :select_answer
  before_action :set_quiz_attempt, only: %i[resume_quiz select_answer]
  before_action :update_session, only: :resume_quiz
  before_action :verify_answer, only: :select_answer
  before_action :verify_backtrack, only: :select_answer

  def start_quiz
    @quiz_attempt = QuizAttempt.create!(
      user_id: current_user.id,
      quiz_id: params[:quiz_id],
      attempt_number: set_attempt_number,
      question_answers: []
    )

    update_session
    next_question
  end

  def resume_quiz
    next_question
  end

  def select_answer
    next_question
  end

  def end_quiz
    @quiz_attempt.update(scores: compute_scores)
    redirect_to show_results_path(@quiz_attempt.quiz, @quiz_attempt)
  end

  private

  def verify_answer
    if @quiz_attempt.next_question_id == @answer.question_id
      add_answer
    end
  end

  def verify_backtrack
    if @quiz_attempt.has_been_answered(@answer.question_id)
      @quiz_attempt.slice_question_answers(@answer.question_id)
      add_answer
    end
  end

  def add_answer
    @quiz_attempt.update(question_answers: @quiz_attempt.question_answers << selected_answer)
    @answer.next_question_order == -1 ? end_quiz : next_question
  end

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_attempt_number
    (QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id])
                .maximum('attempt_number') || 0) + 1
  end

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.where('user_id = ?', current_user.id).find(get_quiz_attempt_id)
  end

  def get_quiz_attempt_id
    if params[:quiz_attempt_id].present?
      params[:quiz_attempt_id]
    elsif @answer.present?
      session["quiz_id_#{@answer.question.quiz_id}_attempt_id"]
    end
  end

  def next_question
    redirect_to quiz_question_path(@quiz_attempt.quiz_id, @quiz_attempt.next_question_id)
  end

  def update_session
    session["quiz_id_#{@quiz_attempt.quiz_id}_attempt_id"] = @quiz_attempt.id
  end

  def selected_answer
    { "question_id": @answer.question_id, "answer_id": @answer.id }
  end

  def compute_scores
    all_variable_values.reduce({}) { |sums, variables| sums.merge(variables) { |_, a, b| a.to_i + b.to_i } }
  end

  def all_variable_values
    @quiz_attempt.question_answers
                 .map(&:symbolize_keys)
                 .map { |question_answer| Answer.find(question_answer[:answer_id]).variable_mods } << initial_values
  end

  def initial_values
    @answer.question.quiz.variables_with_initial_values
  end

end
