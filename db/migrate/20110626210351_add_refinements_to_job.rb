class AddRefinementsToJob < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :exp_date
    add_column :jobs, :earliest_start_date, :datetime
    add_column :jobs, :latest_start_date, :datetime
    add_column :jobs, :end_date, :datetime
    add_column :jobs, :open_ended_end_date, :boolean
  end

  def self.down
    add_column :jobs, :exp_date, :datetime
    remove_column :jobs, :earliest_start_date
    remove_column :jobs, :latest_start_date
    remove_column :jobs, :end_date
    remove_column :jobs, :open_ended_end_date
  end
end
