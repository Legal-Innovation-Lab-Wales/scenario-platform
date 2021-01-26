class Organisation < ApplicationRecord
  has_many :users, foreign_key: :organisation_id
  has_many :quizzes, through: :users
end
