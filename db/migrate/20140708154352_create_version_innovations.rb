class CreateVersionInnovations < ActiveRecord::Migration
  def change
    create_table :version_innovations do |t|
      t.integer :version_id
      t.integer :innovation_id

      t.timestamps
    end
  end
end
