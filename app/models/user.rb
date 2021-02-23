# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable#, :omniauthable

  belongs_to :organisation

  has_many :quizzes, foreign_key: :user_id
  has_many :questions, foreign_key: :user_id
  has_many :answers, foreign_key: :user_id

  has_many :quiz_attempts, foreign_key: :user_id
  has_many :quizzes_attempted, -> { distinct }, through: :quiz_attempts, source: :quiz

  private

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :email,
                        :organisation_id
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, presence: true, on: :create

end
