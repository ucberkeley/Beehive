class Watch < ActiveRecord::Base
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
