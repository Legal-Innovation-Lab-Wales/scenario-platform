class QuizAttemptsController < ApplicationController
  before_action :set_answer, only: :select_answer
  before_action :set_quiz_attempt, only: %i[resume_quiz select_answer]

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
    update_session
    next_question
  end

  def select_answer
    if @quiz_attempt.next_question_id == @answer.question_id
      append_answer
    elsif @quiz_attempt.has_been_answered(@answer.question_id)
      @quiz_attempt.slice_question_answers(@answer.question_id)
      append_answer
    else
      next_question
    end
  end

  def end_quiz
    @quiz_attempt.update(scores: compute_scores)
    render 'attempt_summary'
  end

  private

  def append_answer
    @quiz_attempt.update(question_answers: @quiz_attempt.question_answers << selected_answer)
    if @answer.next_question_order == -1 then end_quiz else next_question end
  end

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_attempt_number
    (QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id])
                .maximum('attempt_number') || 0) + 1
  end

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.find(get_quiz_attempt_id)
  end

  def get_quiz_attempt_id
    if !params[:quiz_attempt_id].nil?
      params[:quiz_attempt_id]
    elsif !@answer.nil?
      session["quiz_id_#{@answer.question.quiz_id}"]
    end
  end

  def next_question
    redirect_to quiz_question_path(@quiz_attempt.quiz_id, @quiz_attempt.next_question_id)
  end

  def update_session
    session["quiz_id_#{@quiz_attempt.quiz_id}"] = @quiz_attempt.id
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
    Quiz.find(@answer.question.quiz.id).variables_with_initial_values
  end

end
