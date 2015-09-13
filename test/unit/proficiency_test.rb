# == Schema Information
#
# Table name: proficiencies
#
#  id          :integer          not null, primary key
#  proglang_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ProficiencyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
