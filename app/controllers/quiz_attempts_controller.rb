class QuizAttemptsController < ApplicationController
  before_action :set_answer, only: :select_answer
  before_action :quiz_attempt, only: :select_answer
  before_action :set_expected_question, only: :select_answer

  def start_quiz
    QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id]).update(active: false)
    QuizAttempt.create!(
      user_id: current_user.id,
      quiz_id: params[:quiz_id],
      attempt_number: set_attempt_number,
      question_answers: [],
      active: true
    )

    $quiz = Quiz.find(params[:quiz_id])
    redirect_to quiz_question_path($quiz.id, helpers.first($quiz))
  end

  def resume_quiz
    # 'Resume Quiz' button will pass the ID of the quiz attempt we'd like to resume
    $quiz_attempt = QuizAttempt.find(params[:quiz_attempt_id])

    # If the scores have been set then this attempt has been completed and so shouldn't be resumable
    if $quiz_attempt.scores.nil?
      # If this attempt is inactive it should be set to active and deactivate all other attempts
      unless $quiz_attempt.active?
        deactivate_all_attempts
        $quiz_attempt.update(active: true)
      end

      # If the now active attempt has answers we should go to the next question after the last answer
      if helpers.has_answers($quiz_attempt)
        redirect_to quiz_question_path($quiz_attempt.quiz_id, helpers.next_question($quiz_attempt).id)
      else
        # Otherwise if we have no answers we should go to the first question
        $quiz = Quiz.find($quiz_attempt.quiz_id)
        $first_question = helpers.first($quiz)
        redirect_to quiz_question_path($quiz_attempt.quiz_id, $first_question.id)
      end
    else
      respond_to do |format|
        format.text { json_response('Quiz attempt [%d] has been completed and so cannot be resumed!' % $quiz_attempt.id, :bad_request) }
      end
    end
  end

  def select_answer
    if @answer.question_id == @expected_question.id
      # Answer was from the expected question => append the question-answer pair
      @quiz_attempt.update(question_answers: @quiz_attempt.question_answers << selected_answer)

      # If there are no further questions end quiz otherwise go to next question.
      if @answer.next_question_order == -1 then end_quiz else redirect_question(@answer.next_question_id) end
    else
      # Answer was not in response to the expected question => user has managed to skip around
      # User has answered this question before => backtracking
      if helpers.has_question(@quiz_attempt, @answer.question_id)
        # Preserve every answer up to the question currently being answered
        $new_question_answers = []
        @quiz_attempt.question_answers.each { |answer| if answer['question_id'] != @answer.question_id then $new_question_answers << answer else break end }
        @quiz_attempt.update(question_answers: $new_question_answers << selected_answer)

        redirect_question(@answer.next_question_id)
      else
        # User hasn't answered this question before => jumped path entirely => don't accept answer =>
        # send them to where they should be given the @expected_question
        redirect_question(@expected_question.id)
      end
    end
  end

  def end_quiz
    @quiz_attempt.update(scores: compute_scores, active: false)
    render 'attempt_summary'
  end

  private

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_attempt_number
    (QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id])
                                      .maximum('attempt_number') || 0) + 1
  end

  def set_expected_question
    $quiz = Quiz.find(@quiz_attempt.quiz_id)

    @expected_question = helpers.has_answers(@quiz_attempt) ? helpers.next_question(@quiz_attempt) : helpers.first($quiz)
  end

  def deactivate_all_attempts
    QuizAttempt.where('user_id = ? and quiz_id = ?', current_user.id, params[:quiz_id]).update(active: false)
  end

  def quiz_attempt
    @quiz_attempt = helpers.quiz_attempt(current_user.id, @answer.question.quiz.id)
  end

  def redirect_question(question_id)
    redirect_to quiz_question_path(@quiz_attempt.quiz_id, question_id)
  end

  def selected_answer
    { "question_id": @answer.question_id, "answer_id": params[:answer_id] }
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
