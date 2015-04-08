class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.integer :qtest_id
      t.integer :question_seq
      t.integer :question_number
      t.integer :answer

      t.timestamps
    end
  end
end
