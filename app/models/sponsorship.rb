# == Schema Information
#
# Table name: sponsorships
#
#  id         :integer          not null, primary key
#  faculty_id :integer
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Sponsorship < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :job
end
