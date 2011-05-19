class Department < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : text 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

	has_many :jobs
end
