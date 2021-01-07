class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :question, foreign_key: 'next_question_ID'
end
