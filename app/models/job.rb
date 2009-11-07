class Job < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :pictures
end
