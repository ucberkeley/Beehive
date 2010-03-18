class CreateFacultiesReviews < ActiveRecord::Migration
	def self.up
		create_table :faculties_reviews, :id => false do |t|
			t.references :faculty
			t.references :review
		end
	end
	
	def self.down
		drop_table :faculties_reviews
	end
end