class AddNameAndDescToCourses < ActiveRecord::Migration
  def self.up
	add_column :courses, :name, :string
	add_column :courses, :desc, :text
  end
  

  def self.down
	remove_column :courses, :name
	remove_column :courses, :desc
  end
end
