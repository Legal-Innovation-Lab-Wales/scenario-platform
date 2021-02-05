class QuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user

  validates_presence_of :user_id, :quiz_id, :attempt_number
end
