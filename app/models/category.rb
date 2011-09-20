class Category < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : string 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  has_many :jobs, :through => :categories_jobs
  
  has_many :interests
  has_many :users, :through => :interests
  
end
