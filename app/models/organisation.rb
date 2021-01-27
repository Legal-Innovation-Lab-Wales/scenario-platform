# app/models/organisation.rb
class Organisation < ApplicationRecord
  has_many :users, foreign_key: :organisation_id
  has_many :quizzes, through: :users

  # validations
  validates_presence_of :name
end
