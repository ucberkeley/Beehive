class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  has_and_belongs_to_many :categories
  has_many :pictures
  
  has_many :watches
  has_many :users, :through => :watches
  has_many :sponsorships
  has_many :faculties, :through => :sponsorships
  has_many :coursereqs
  has_many :courses, :through => :coursereqs
  has_many :proglangreqs
  has_many :proglangs, :through => :proglangreqs
  
  # Before carrying out validations and creating the actual object, 
  # handle the name of the category(ies), the required courses, and the 
  # desired proglangs so as to deal with associations properly.
  before_validation :handle_categories
  before_validation :handle_courses
  before_validation :handle_proglangs
  
  acts_as_taggable
  acts_as_indexed :fields => [:title, :desc, :tag_list]
  
  validates_presence_of :title, :desc, :exp_date, :num_positions, :department
  
  # Validates that expiration dates are no earlier than right now.
  validates_each :exp_date do |record, attr, value|
	record.errors.add attr, 'Expiration date cannot be earlier than right now.' if value < Time.now - 1.hour
  end
  
  validates_length_of :title, :within => 10..200
  validates_numericality_of :num_positions
  validate :validate_sponsorships
  
  
  attr_accessor :category_names
  attr_accessor :course_names
  attr_accessor :proglang_names
  
  # If true, handle_categories, handle_courses, and handle_proglangs don't do anything. 
  # The purpose of this is so that in activating a job, these data aren't lost.
  @skip_handlers = false
  attr_accessor :skip_handlers
  
  def self.active_jobs
    Job.find(:all, :conditions => {:active => true}, :order => "created_at DESC")
  end
  
  def self.smartmatches_for(my) # matches for a user
	  courses = my.course_list_of_user.gsub ",", " "
  	cats = my.category_list_of_user.gsub ",", " "
  	pls = my.proglang_list_of_user.gsub ",", " "
  	query = "#{cats} #{courses} #{pls}"
  	#Job.find_by_solr_by_relevance(query)
    self.find_jobs(query, 0, 0, 0, 0)
  end
  
  # This is the main search handler.
  # It should be the ONLY interface between search queries and jobs;
  # hopefully this will make the choice of search engine transparent
  # to our app.
  #
  # Currently uses the simple acts_as_index
  #   (http://douglasfshearer.com/blog/rails-plugin-acts_as_indexed)
  #
  def self.find_jobs(query, department, faculty, paid, credit)
    paid = from_binary(paid)
    credit = from_binary(credit)
    
    #results = Job.find(:all, :conditions => {:active => true }) # TODO: exclude expired jobs too
    jobs = Job.active_jobs
    jobs = Job.find_with_index(query, {:conditions => {:active=>true}}) if !query.empty?
    
    jobs = jobs.select {|j| j.department_id.to_i == department } if department != 0
    jobs = jobs.select {|j| j.faculties.collect{|f| f.id.to_i}.include?(faculty) }  if faculty != 0
    jobs = jobs.select {|j| j.paid == paid} if paid
    jobs = jobs.select {|j| j.credit == credit} if credit
    return jobs
  end
   
  def self.find_recently_added(n)
	Job.find(:all, :order => "created_at DESC", :limit=>n)
  end
  
  # Returns a string containing the category names taken by job @job
  # e.g. "robotics,signal processing"
  def category_list_of_job
  	category_list = ''
  	categories.each do |cat|
  		category_list << cat.name + ','
  	end
  	category_list[0..(category_list.length - 2)].downcase
  end
  
  # Returns a string containing the 'required course' names taken by job @job
  # e.g. "CS61A,CS61B"
  def course_list_of_job
  	course_list = ''
  	courses.each do |c|
  		course_list << c.name + ','
  	end
  	course_list[0..(course_list.length - 2)].upcase
  end
  
  # Returns a string containing the 'desired proglang' names taken by job @job
  # e.g. "java,scheme,c++"
  def proglang_list_of_job
  	proglang_list = ''
  	proglangs.each do |pl|
  		proglang_list << pl.name + ','
  	end
  	proglang_list[0..(proglang_list.length - 2)].downcase
  end  
  
  protected
  
  	# Parses the textbox list of category names from "Signal Processing, Robotics"
	# etc. to an enumerable object categories
	def handle_categories
		unless skip_handlers
			self.categories = []  # eliminates any previous categories_jobs so as to avoid duplicates
			category_array = []
			category_array = category_names.split(',').uniq if ! category_names.nil?
			category_array.each do |item|
				self.categories << Category.find_or_create_by_name(item.downcase.strip)
			end
		end
	end
	
	# Parses the textbox list of courses from "CS162,CS61A,EE123"
	# etc. to an enumerable object courses
	def handle_courses
		unless skip_handlers
			self.courses = []  # eliminates any previous enrollments so as to avoid duplicates
			course_array = []
			course_array = course_names.split(',').uniq if ! course_names.nil?
			course_array.each do |item|
				self.courses << Course.find_or_create_by_name(item.upcase.strip)
			end
		end
	end
	
	# Parses the textbox list of proglangs from "java,c,scheme"
	# etc. to an enumerable object proglangs
	def handle_proglangs
		unless skip_handlers
			self.proglangs = []  # eliminates any previous enrollments so as to avoid duplicates
			proglang_array = []
			proglang_array = proglang_names.split(',').uniq if ! proglang_names.nil?
			proglang_array.each do |pl|
				self.proglangs << Proglang.find_or_create_by_name(pl.downcase.strip)
			end
		end
	end	
	
	def validate_sponsorships
	  errors.add_to_base("Job posting must have at least one faculty sponsor.") unless (sponsorships.size > 0)
	end
	
	def self.from_binary(n)
	  return false if n == 0
	  return true
  end

	
end
