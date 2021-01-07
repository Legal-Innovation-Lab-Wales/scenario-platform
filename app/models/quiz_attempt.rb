class QuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
end
