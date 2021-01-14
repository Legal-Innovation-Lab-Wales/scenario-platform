class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable#, :omniauthable

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :email,
                        :organisation
  validates :email, uniqueness: { case_sensitive: false }

end
git