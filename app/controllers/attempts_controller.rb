# app/controllers/attempts_controller.rb
class AttemptsController < ApplicationController
  before_action :set_answer, only: :select_answer
  before_action :set_attempt, only: %i[resume_scenario select_answer]
  before_action :update_session, only: :resume_scenario
  before_action :verify_answer, :verify_backtrack, only: :select_answer

  def start_scenario
    @attempt = Attempt.create!(
      user_id: current_user.id,
      scenario_id: params[:scenario_id],
      attempt_number: set_attempt_number,
      question_answers: []
    )

    update_session
    next_question
  end

  def resume_scenario
    next_question
  end

  def select_answer
    next_question
  end

  def end_scenario
    @attempt.update(scores: compute_scores)
    redirect_to show_results_path(@attempt.scenario, @attempt)
  end

  private

  def verify_answer
    add_answer if @attempt.next_question_id == @answer.question_id
  end

  def verify_backtrack
    return unless @attempt.been_answered?(@answer.question_id)

    @attempt.slice_question_answers(@answer.question_id)
    add_answer
  end

  def add_answer
    @attempt.update(question_answers: @attempt.question_answers << selected_answer)
    @answer.next_question_order == -1 ? end_scenario : next_question
  end

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_attempt_number
    (Attempt.where('user_id = ? and scenario_id = ?', current_user.id, params[:scenario_id])
                .maximum('attempt_number') || 0) + 1
  end

  def set_attempt
    @attempt = Attempt.where('user_id = ?', current_user.id).find(attempt_id)
  end

  def attempt_id
    if params[:attempt_id].present?
      params[:attempt_id]
    elsif @answer.present?
      session["scenario_id_#{@answer.question.scenario_id}_attempt_id"]
    end
  end

  def next_question
    redirect_to scenario_question_path(@attempt.scenario_id, @attempt.next_question_id)
  end

  def update_session
    session["scenario_id_#{@attempt.scenario_id}_attempt_id"] = @attempt.id
  end

  def selected_answer
    { "question_id": @answer.question_id, "answer_id": @answer.id }
  end

  def compute_scores
    all_variable_values.reduce({}) { |sums, variables| sums.merge(variables) { |_, a, b| a.to_i + b.to_i } }
  end

  def all_variable_values
    @attempt.question_answers
            .map(&:symbolize_keys)
            .map { |question_answer| Answer.find(question_answer[:answer_id]).variable_mods } << initial_values
  end

  def initial_values
    @answer.question.scenario.variables_with_initial_values
  end
end
