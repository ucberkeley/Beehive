class AddDepartmentAssociationToJob < ActiveRecord::Migration
  def self.up
	add_column :jobs, :department_id, :integer
  end

  def self.down
	remove_column :jobs, :department_id
  end
end
