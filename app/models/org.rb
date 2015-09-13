# == Schema Information
#
# Table name: orgs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  abbr       :string(255)
#

class Org < ActiveRecord::Base
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
