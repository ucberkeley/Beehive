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

require 'test_helper'

class CoursereqTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
