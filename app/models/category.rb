# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base

  has_and_belongs_to_many :jobs
  has_many :interests
  has_many :users, :through => :interests
  
end
