class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  has_and_belongs_to_many :categories
  has_many :pictures
  
  has_many :sponsorships
  has_many :faculties, :through => :sponsorships
  
  acts_as_solr :fields => [:title, :desc]
  
  validates_presence_of :title, :desc, :exp_date
  
  def self.find_recently_added(n)
	Job.find(:all, :order => "created_at DESC", :limit=>n)
  end
  
end
