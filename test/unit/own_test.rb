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

require 'test_helper'

class OwnTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
