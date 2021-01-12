class Question < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :answers
end


