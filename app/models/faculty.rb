class Faculty < ActiveRecord::Base
  # ASSOCIATIONS (abc order)
  belongs_to :department
  
	has_many :jobs, :through => :sponsorships  
  has_many :sponsorships
  
  def name_with_dept
    return self.name + ' (' + self.department.abbrev + ')'
  end
end
