class Review < ActiveRecord::Base
    has_and_belongs_to_many :faculties
	
	# validations
	#validates_presence_of :
	
  
end
