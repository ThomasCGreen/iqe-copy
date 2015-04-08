class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.integer :version_id
      t.integer :question_number
      t.string :trigger_name
      t.integer :normal_weight
      t.integer :double_weight

      t.timestamps
    end
  end
end
