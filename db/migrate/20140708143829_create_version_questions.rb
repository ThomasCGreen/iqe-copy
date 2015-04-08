class CreateVersionQuestions < ActiveRecord::Migration
  def change
    create_table :version_questions do |t|
      t.integer :version_id
      t.integer :question_id

      t.timestamps
    end
  end
end
