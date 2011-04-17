class Watch < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   job_id     : integer 
  #   user_id    : integer 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  belongs_to :job
  belongs_to :user
  
  def unread?
    self.updated_at < job.updated_at
  end
  
  def mark_read
    self.updated_at = Time.now
    self.save
  end
  
end
