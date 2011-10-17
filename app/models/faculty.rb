class Faculty < ActiveRecord::Base

  # === List of columns ===
  #   id            : integer 
  #   name          : string 
  #   email         : string 
  #   created_at    : datetime 
  #   updated_at    : datetime 
  #   department_id : integer 
  # =======================

  has_many :sponsorships
  has_many :jobs, :through => :sponsorships
  has_many :reviews
  belongs_to :department

  validates_presence_of :name

  attr_accessible :name, :email, :department_id

end
