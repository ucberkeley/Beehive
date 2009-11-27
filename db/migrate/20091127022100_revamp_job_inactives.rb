class RevampJobInactives < ActiveRecord::Migration
  def self.up
    drop_table :job_inactives
	add_column :jobs, :activation_code, :integer
	add_column :jobs, :active, :boolean
  end

  def self.down
    remove_column :jobs, :activation_code
	remove_column :jobs, :active
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
end
