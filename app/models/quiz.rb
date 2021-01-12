class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions

  before_create :add_org_to_quiz

  private

  def add_org_to_quiz
    self.organisation = user.organisation
  end
end
