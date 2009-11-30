class Category < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  
  has_many :interests
  has_many :users, :through => :interests
  
end
