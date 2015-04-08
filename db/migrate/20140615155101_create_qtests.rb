class CreateQtests < ActiveRecord::Migration
  def change
    create_table :qtests do |t|
      t.string :license_key
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :state
      t.string :gender
      t.string :age_range
      t.string :department
      t.string :level
      t.string :degree
      t.integer :years_in_workforce
      t.string :innovation_style
      t.string :driving_strength_1
      t.string :driving_strength_2
      t.string :latent_strength
      t.boolean :unused
      t.boolean :license_key_sent
      t.integer :question_finished
      t.boolean :results_sent_to_infusionsoft
      t.integer :major_version
      t.integer :minor_version
      t.boolean :free_test
      t.string :coach_first_name
      t.string :coach_last_name
      t.string :coach_email
      t.boolean :company
      t.boolean :send_to_client
      t.integer :multi_license

      t.timestamps
    end
  end
end
