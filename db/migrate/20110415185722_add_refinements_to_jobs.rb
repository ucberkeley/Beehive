class AddRefinementsToJobs < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :exp_date
    add_column :jobs, :earliest_start_date, :datetime
    add_column :jobs, :latest_start_date, :datetime
    add_column :jobs, :end_date, :datetime
    add_column :jobs, :open_ended_end_date, :boolean, :default => false, :null => false
    add_column :jobs, :paid, :boolean, :default => false, :null => false
    add_column :jobs, :credit, :boolean, :default => false, :null => false
  end

  def self.down
    add_column :jobs, :exp_date, :datetime
    remove_column :jobs, :open_ended_end_date
    remove_column :jobs, :end_date
    remove_column :jobs, :latest_start_date
    remove_column :jobs, :earliest_start_date
    remove_column :jobs, :paid
    remove_column :jobs, :credit
  end
end
