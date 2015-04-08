class ChangeCompanyInQtests < ActiveRecord::Migration
  def change
    change_column :qtests, :company, :string
  end
end
