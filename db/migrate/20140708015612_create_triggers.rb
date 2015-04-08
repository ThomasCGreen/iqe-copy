class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :trigger_name
      t.string :trigger_type
      t.integer :order
      t.text :trigger_words

      t.timestamps
    end
  end
end
