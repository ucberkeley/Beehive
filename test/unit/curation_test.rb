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

require 'test_helper'

class CurationsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
