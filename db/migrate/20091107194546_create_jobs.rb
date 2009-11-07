class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.references :user
      t.string :title
      t.text :desc
      t.references :category
      t.datetime :exp_date
      t.integer :num_positions
      t.boolean :paid
      t.boolean :credit

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
