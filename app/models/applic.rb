class Applic < ActiveRecord::Base

  # === List of columns ===
  #   id            : integer 
  #   job_id        : integer 
  #   user_id       : integer 
  #   message       : text 
  #   resume_id     : integer 
  #   transcript_id : integer 
  #   created_at    : datetime 
  #   updated_at    : datetime 
  # =======================

  belongs_to :job
  belongs_to :user
end
