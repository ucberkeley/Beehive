class Org < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : string 
  #   desc       : text 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  attr_accessible :desc, :name
  has_many :members, :through => :memberships, :source => :user
  has_many :jobs, :through => :curations
end
