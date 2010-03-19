class Review < ActiveRecord::Base
    belongs_to :user
	belongs_to :faculty
	
	# validations
	validates_presence_of :faculty, :body, :rating
	validates_length_of :body, :minimum => 50
	validates_numericality_of :rating
	
	
  
end
