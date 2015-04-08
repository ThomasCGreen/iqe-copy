class CreateInnovations < ActiveRecord::Migration
  def change
    create_table :innovations do |t|
      t.string :style
      t.string :innovation_type
      t.integer :order
      t.text :innovation_words

      t.timestamps
    end
  end
end
