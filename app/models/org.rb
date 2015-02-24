class Org < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : string 
  #   desc       : text 
  #   created_at : datetime 
  #   updated_at : datetime 
  #   abbr       : string 
  # =======================

  attr_accessible :desc, :name
  has_many :memberships
  has_many :members, :through => :memberships, :source => :user
  has_many :curations
  has_many :jobs, :through => :curations

  # overriden so that org_path uses 
  def to_param
    abbr
  end

  def self.from_param(param)
    find_by_abbr!(param)
  end
end
