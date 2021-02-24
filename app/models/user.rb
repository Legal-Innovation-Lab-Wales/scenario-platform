# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable#, :omniauthable

  belongs_to :organisation

  has_many :scenarios, foreign_key: :user_id
  has_many :questions, foreign_key: :user_id
  has_many :answers, foreign_key: :user_id

  has_many :attempts, foreign_key: :user_id
  has_many :scenarios_attempted, -> { distinct }, through: :attempts, source: :scenario

  private

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :email,
                        :organisation_id,
                        :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true

end
