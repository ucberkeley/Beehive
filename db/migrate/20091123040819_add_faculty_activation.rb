class AddFacultyActivation < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :job_inactive
  end
end
