# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  grade      :string(255)
#  semester   :string(255)
#  course_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Enrollment < ActiveRecord::Base

  belongs_to :course
  belongs_to :user
end
