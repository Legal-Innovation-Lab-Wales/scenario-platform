# app/models/organisation.rb
class Organisation < ApplicationRecord
  has_many :users, foreign_key: :organisation_id
  has_many :scenarios, through: :users

  # validations
  validates_presence_of :name

  def admins
    users.admins
  end

  def unapproved_users
    users.unapproved
  end
end
