# == Schema Information
#
# Table name: owns
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Own < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
end
