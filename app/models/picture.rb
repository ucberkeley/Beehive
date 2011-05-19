class Picture < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   url        : string 
  #   user_id    : integer 
  #   job_id     : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :user
  belongs_to :job
end
