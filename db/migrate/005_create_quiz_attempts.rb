class CreateQuizAttempts < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :quiz_attempts do |t|
      t.belongs_to :quiz, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :attempt_number
      t.json :question_answers
      t.hstore :scores

      t.timestamps
    end

    add_index :quiz_attempts, [:quiz_id, :user_id, :attempt_number], unique: true
  end
end
