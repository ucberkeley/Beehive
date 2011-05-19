class Sponsorship < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   faculty_id : integer 
  #   job_id     : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :faculty
  belongs_to :job
end
