# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  desc       :text
#

class Course < ActiveRecord::Base

  has_many :enrollments
  has_many :users, :through => :enrollments
  has_many :coursereqs
  has_many :jobs, :through => :coursereqs
end
