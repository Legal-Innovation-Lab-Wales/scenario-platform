# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable#, :omniauthable

  has_many :quizzes, foreign_key: :user_id
  has_many :questions, foreign_key: :user_id
  has_many :answers, foreign_key: :user_id
  has_many :quiz_attempts, foreign_key: :user_id


  private

  # validations
  validates_presence_of :first_name, :last_name, :email, :organisation

end
