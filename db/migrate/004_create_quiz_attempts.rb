class CreateQuizAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :quiz_attempts do |t|
      t.belongs_to :quiz, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :attempt_number
      t.hstore :question_answers
      t.integer :scores, array: true, default: []

      t.timestamps
    end
  end
end
