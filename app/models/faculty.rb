class Faculty < ActiveRecord::Base

  # === List of columns ===
  #   id            : integer 
  #   name          : string 
  #   email         : string 
  #   department_id : integer 
  #   uid           : integer 
  #   created_at    : datetime 
  #   updated_at    : datetime 
  # =======================

  # ASSOCIATIONS (abc order)
  belongs_to :department
  
	has_many :jobs, :through => :sponsorships  
  has_many :sponsorships
  
  def name_with_dept
    return self.name + ' (' + self.department.abbrev + ')'
  end
end
