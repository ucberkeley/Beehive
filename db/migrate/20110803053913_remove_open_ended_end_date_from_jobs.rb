class RemoveOpenEndedEndDateFromJobs < ActiveRecord::Migration
  def self.up
    Job.all.each do |j|
      j.update_attribute(:end_date, nil) if j.open_ended_end_date && j.end_date != nil
    end

    remove_column :jobs, :open_ended_end_date
  end

  def self.down
    add_column :jobs, :open_ended_end_date, :boolean 
    Job.reset_column_information
    Job.all.each do |j|
      next unless j.end_date.nil?
      j.update_attribute(:open_ended_end_date, true) if j.end_date.nil?
    end
  end
end
