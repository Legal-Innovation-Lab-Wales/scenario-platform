class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.belongs_to :quiz, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :order
      t.string :text
      t.string :description

      t.timestamps
    end
  end
end
