# == Schema Information
#
# Table name: orgs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  abbr       :string(255)
#

require 'test_helper'

class OrgTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
