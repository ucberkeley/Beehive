class Review < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   user_id    : integer 
  #   body       : text 
  #   rating     : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  #   faculty_id : integer 
  # =======================

    belongs_to :user
	belongs_to :faculty
	
	# validations
	validates_presence_of :faculty, :body, :rating
	validates_length_of :body, :minimum => 50
	validates_numericality_of :rating
	
	
  
end
