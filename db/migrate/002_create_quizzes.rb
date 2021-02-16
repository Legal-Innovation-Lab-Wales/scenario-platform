# db/migrate/002_create_quizzes.rb
class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :quizzes do |t|

      t.belongs_to :user, null: false, foreign_key: true

      t.string :name
      t.text :description
      t.string :variables, array: true, default: []
      t.integer :variable_initial_values, array: true, default: []
      t.hstore :variables_with_initial_values
      t.boolean :available, default: false

      t.timestamps
    end
  end
end
