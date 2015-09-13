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

require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
