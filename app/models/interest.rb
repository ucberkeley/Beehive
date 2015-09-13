# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Interest < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
end
