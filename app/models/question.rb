# app/models/question.rb
class Question < ApplicationRecord
  belongs_to :scenario
  belongs_to :user
  has_many :answers, dependent: :destroy, foreign_key: :question_id
end


