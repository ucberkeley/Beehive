class Review < ActiveRecord::Base
    belongs_to :user
	belongs_to :faculty
	
	# validations
	#validates_presence_of :
	
  
end
