class Category < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : string 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  has_and_belongs_to_many :jobs
  has_many :interests
  has_many :users, :through => :interests
  
end
