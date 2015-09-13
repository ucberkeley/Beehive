# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  org_id     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  belongs_to :org
  belongs_to :user
end
