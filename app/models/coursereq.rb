class Coursereq < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   course_id  : integer 
  #   job_id     : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :course
  belongs_to :job
end
