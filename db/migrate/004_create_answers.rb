# db/migrate/004_create_answers.rb
class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :answers do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :question, null: false, foreign_key: true
      t.string :text
      t.hstore :variable_mods
      t.integer :next_question_order
      t.integer :next_question_id

      t.timestamps
    end
  end
end
