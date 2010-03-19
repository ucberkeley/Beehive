class RemoveAndFixFacultiesReviews < ActiveRecord::Migration
	def self.up
		drop_table :faculties_reviews
		add_column :reviews, :faculty_id, :integer
	end
	
	def self.down
		remove_column :reviews, :faculty_id
	end
end