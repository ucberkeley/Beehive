# == Schema Information
#
# Table name: curations
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  org_id     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Curation < ActiveRecord::Base

  belongs_to :job
  belongs_to :org
  belongs_to :user
end
