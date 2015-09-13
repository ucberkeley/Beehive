# == Schema Information
#
# Table name: proglangreqs
#
#  id          :integer          not null, primary key
#  job_id      :integer
#  proglang_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ProglangreqTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
