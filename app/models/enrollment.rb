class Enrollment < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   grade      : string 
  #   semester   : string 
  #   course_id  : integer 
  #   user_id    : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :course
  belongs_to :user
end
