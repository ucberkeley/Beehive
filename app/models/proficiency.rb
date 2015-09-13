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

class Proficiency < ActiveRecord::Base
  belongs_to :proglang
  belongs_to :user
end
