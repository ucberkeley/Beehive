class PopulateEecsToDepartments < ActiveRecord::Migration
  def self.up
	    Department.create :name => "EECS"
  end

  def self.down
		Department.find_by_name(:first, "EECS").each { |d| d.destroy }
  end
end
