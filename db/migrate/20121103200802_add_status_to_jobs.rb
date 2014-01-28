class AddStatusToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :status, :int, {:default=>0}
  end

  def self.down
    remove_column :jobs, :status
  end
end
