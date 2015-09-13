# == Schema Information
#
# Table name: coursereqs
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Coursereq < ActiveRecord::Base
  belongs_to :course
  belongs_to :job
end
