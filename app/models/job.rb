class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  has_and_belongs_to_many :categories
  has_many :pictures
  
  has_many :sponsorships
  has_many :faculties, :through => :sponsorships
  
  # Before carrying out validations and creating the actual object, 
  # handle the name of the category(ies) so as to deal with associations
  # properly.
  before_validation :handle_categories
  
  acts_as_solr :fields => [:title, :desc]
  
  validates_presence_of :title, :desc, :exp_date, :num_positions, :department
  
  attr_accessor :category_names
  
  def self.find_recently_added(n)
	Job.find(:all, :order => "created_at DESC", :limit=>n)
  end
  
  # Returns a string containing the category names taken by job @job
  # e.g. "robotics,signal processing"
  def category_list_of_job
  	category_list = ''
  	categories.each do |item|
  		category_list << item.name + ','
  	end
  	category_list[0..(category_list.length - 2)].downcase
  end
  
  protected
  
  	# Parses the textbox list of category names from "Signal Processing, Robotics"
	# etc. to an enumerable object categories
	def handle_categories
		self.categories = []  # eliminates any previous categories_jobs so as to avoid duplicates
		category_array = []
		category_array = category_names.split(',').uniq if ! category_names.nil?
		category_array.each do |item|
			self.categories << Category.find_or_create_by_name(item.downcase.strip)
		end
	end
  
end
