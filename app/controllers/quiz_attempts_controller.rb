class QuizAttemptsController < ApplicationController
  before_action :set_answer, only: :select_answer
  before_action :quiz_attempt, only: :select_answer
  before_action :set_expected_question, only: :select_answer

  def start_quiz
    QuizAttempt.create!(
      user_id: current_user.id,
      quiz_id: params[:quiz_id],
      attempt_number: set_attempt_number,
      question_answers: []
    )

    redirect_to quiz_question_path(params[:quiz_id], Quiz.find(params[:quiz_id]).questions.find_by(order: 0))
  end

  def select_answer
    if @answer.question_id == @expected_question.id
      # Answer was from the expected question => append the question-answer pair.
      @quiz_attempt.update(question_answers: @quiz_attempt.question_answers << selected_answer)

      # If there are no further questions end quiz otherwise go to next question.
      if @answer.next_question_order == -1 then end_quiz else redirect_question(@answer.next_question_id) end
    else
      # Answer was not in response to the expected question => user has managed to skip around.
      # User has answered this question before => backtracking.
      if helpers.match_question(@quiz_attempt, @answer.question_id)
        # Preserve every answer up to the question currently being answered.
        $new_question_answers = []
        @quiz_attempt.question_answers.each { |answer| if answer['question_id'] != @answer.question_id then $new_question_answers << answer else break end }
        @quiz_attempt.update(question_answers: $new_question_answers << selected_answer)

        redirect_question(@answer.next_question_id)
      else
        # User hasn't answered this question before => jumped path entirely => don't accept answer =>
        # send them to where they should be given the @expected_question.
        redirect_question(@expected_question.id)
      end
    end
  end

  def end_quiz
    @quiz_attempt.update(scores: compute_scores)
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
    if @quiz_attempt.question_answers.length > 0
      # User has attempted this quiz already => expected question is the next question leading on from the last given answer.
      $last_answer = Answer.find(@quiz_attempt.question_answers.last['answer_id'])
      @expected_question = Question.find($last_answer.next_question_id)
    else
      # User has not attempted this quiz already => expected question is the first question for the quiz.
      @expected_question = Quiz.find(@quiz_attempt.quiz_id).questions.find_by(order: 0)
    end
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
