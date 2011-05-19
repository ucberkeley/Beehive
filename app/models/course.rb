class Course < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  #   name       : string 
  #   desc       : text 
  # =======================

  has_many :enrollments
  has_many :users, :through => :enrollments
  has_many :coursereqs
  has_many :jobs, :through => :coursereqs
end
