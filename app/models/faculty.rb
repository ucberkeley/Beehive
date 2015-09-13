# == Schema Information
#
# Table name: faculties
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  email         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  department_id :integer
#  calnetuid     :string
#

class Faculty < ActiveRecord::Base

  default_scope {order('name')}
  has_many :sponsorships
  has_many :jobs, :through => :sponsorships
  has_many :reviews
  belongs_to :department

  validates_presence_of :name
end
