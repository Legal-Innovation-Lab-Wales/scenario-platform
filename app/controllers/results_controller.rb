# app/controllers/results_controller.rb
class ResultsController < ApplicationController
  before_action :set_attempt, :verify_results, only: :show

  # GET /scenarios/:scenario_id/results/:attempt_id
  def show
    respond_to do |format|
      format.html
      format.json { json_response(@attempt, :ok) }
    end
  end

  private

  def set_attempt
    @attempt = Attempt.where('user_id = ?', current_user.id).find(params[:attempt_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to scenario_path(params[:scenario_id])
  end

  def verify_results
    redirect_to scenario_question_path(@attempt.scenario_id, @attempt.next_question_id) unless @attempt.completed
  end
end
