class AddTagValueToInnovations < ActiveRecord::Migration
  def change
    add_column :innovations, :tag_value, :integer
  end
end
