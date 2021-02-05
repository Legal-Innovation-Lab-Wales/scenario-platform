class QuizAttemptsController < ApplicationController
  before_action :set_quiz_attempt, only: [:select_answer, :attempt_summary]

  def start_quiz
    QuizAttempt.create!(
      user_id: current_user.id,
      quiz_id: params[:quiz_id],
      attempt_number: set_attempt_number,
      question_answers: []
    )

    respond_to do |format|
      format.html { redirect_to quiz_question_path(params[:quiz_id], Quiz.find(params[:quiz_id]).questions.find_by(order: 0)) }
      # TODO: does this need to respond to JSON at the moment?
      # format.json { json_response(@question.as_json, :created) }
    end
  end

  def select_answer
    # Params from answer button:
    # quiz_id: @question.quiz_id,
    # question_id: @question.id,
    # answer_id: answer.id,
    # next_question_id: answer.next_question_id,
    # next_question_order: answer.next_question_order

    end_quiz and return if params[:next_question_order] == '-1'

    # TODO: Handle when someone goes backwards

    @quiz_attempt.update(question_answers: @quiz_attempt.question_answers << selected_answer)
    redirect_to quiz_question_path(Question.find(params[:question_id]).quiz_id, params[:next_question_id])
  end

  def end_quiz
    @quiz_attempt.update(scores: compute_scores)
    render 'attempt_summary'
  end

  private

  def set_attempt_number
    (QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id])
                                      .maximum('attempt_number') || 0) + 1
  end

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id])
                                .order(:attempt_number).last
  end

  def selected_answer
    { "question_id": params[:question_id], "answer_id": params[:answer_id] }
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
    Quiz.find(params[:quiz_id]).variables_with_initial_values
  end

end
