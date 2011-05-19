class Faculty < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : string 
  #   email      : string 
  #   department : string 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

	has_many :sponsorships
	has_many :jobs, :through => :sponsorships
	has_many :reviews
end
