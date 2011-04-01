class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.references :user
      t.string :title
      t.text :desc
      t.datetime :exp_date
      t.integer :num_positions
      t.integer :department_id
      t.string :activation_code
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
