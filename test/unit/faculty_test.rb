# == Schema Information
#
# Table name: faculties
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  email         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  department_id :integer
#  calnetuid     :string
#

require 'test_helper'

class FacultyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
