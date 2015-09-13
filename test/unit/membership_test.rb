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

require 'test_helper'

class MembershipsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
