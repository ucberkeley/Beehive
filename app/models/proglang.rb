class Proglang < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : string 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

	has_many :proglangreqs
	has_many :jobs, :through => :proglangreqs
end
