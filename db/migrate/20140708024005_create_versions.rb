class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :major_version
      t.integer :minor_version

      t.timestamps
    end
  end
end
