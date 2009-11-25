class FixJobInactivesTable < ActiveRecord::Migration
# This migration drops the "job_inactive" table and creates the "job_inactives" 
# table in order to comply with Rails conventions.
  def self.up
	    drop_table :job_inactive
		create_table :job_inactives do |t|
		  t.references :user
		  t.string :title
		  t.text :desc
		  t.references :category
		  t.datetime :exp_date
		  t.integer :num_positions
		  t.boolean :paid
		  t.boolean :credit
		  t.integer :activation_code
		  t.timestamps
		end
  end

  def self.down
	    drop_table :job_inactives
		create_table :job_inactive do |t|
		  t.references :user
		  t.string :title
		  t.text :desc
		  t.references :category
		  t.datetime :exp_date
		  t.integer :num_positions
		  t.boolean :paid
		  t.boolean :credit
		  t.integer :activation_code
		  t.timestamps
		end
	end
end
