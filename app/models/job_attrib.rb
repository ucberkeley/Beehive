class JobAttrib < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   job_id     : integer 
  #   attrib_id  : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :job
  belongs_to :attrib
end
