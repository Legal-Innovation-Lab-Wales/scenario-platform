class CreateAttempts < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :attempts do |t|
      t.belongs_to :scenario, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :attempt_number
      t.json :question_answers
      t.hstore :scores

      t.timestamps
    end

    add_index :attempts, [:scenario_id, :user_id, :attempt_number], unique: true
  end
end
