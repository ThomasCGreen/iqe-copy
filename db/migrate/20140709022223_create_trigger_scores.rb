class CreateTriggerScores < ActiveRecord::Migration
  def change
    create_table :trigger_scores do |t|
      t.integer :qtest_id
      t.string :trigger_name
      t.decimal :score, precision: 8, scale: 6

      t.timestamps
    end
  end
end
