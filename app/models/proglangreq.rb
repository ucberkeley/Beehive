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

class Proglangreq < ActiveRecord::Base
  belongs_to :job
  belongs_to :proglang
end
