class CreateVersionTriggers < ActiveRecord::Migration
  def change
    create_table :version_triggers do |t|
      t.integer :version_id
      t.integer :trigger_id

      t.timestamps
    end
  end
end
