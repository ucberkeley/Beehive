class Job < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :pictures
  has_many :sponsors
  has_many :faculties, :through => :sponsors
  
  acts_as_solr :fields => [:title, :desc]
  
end
