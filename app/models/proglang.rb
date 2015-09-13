# == Schema Information
#
# Table name: proglangs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Proglang < ActiveRecord::Base
  has_many :proglangreqs
  has_many :jobs, :through => :proglangreqs
end
