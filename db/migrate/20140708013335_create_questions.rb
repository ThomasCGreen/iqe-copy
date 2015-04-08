class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :question_number
      t.string :question_words
      t.boolean :inverted

      t.timestamps
    end
  end
end
