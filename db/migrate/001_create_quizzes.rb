class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzes do |t|

      t.belongs_to :user, null: false, foreign_key: true

      t.string :variables, array: true, default: []
      t.integer :variable_initial_values, array: true, default: []
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
