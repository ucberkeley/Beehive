class AddIsFacultyToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :is_faculty, :boolean, :default => false
  end
  

  def self.down
	remove_column :users, :is_faculty
  end
end
