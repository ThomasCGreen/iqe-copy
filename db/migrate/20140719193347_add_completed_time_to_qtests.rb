class AddCompletedTimeToQtests < ActiveRecord::Migration
  def change
    add_column :qtests, :completed_time, :datetime
  end
end
