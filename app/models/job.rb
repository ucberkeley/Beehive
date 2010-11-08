class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  has_and_belongs_to_many :categories
  has_many :pictures
  
  has_many :watches
  has_many :applics
  #has_many :applicants, :class_name => 'User', :through => :applics
  has_many :applicants, :through => :applics, :source => :user
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
  
  acts_as_taggable

  # ThinkingSphinx
  define_index do
    indexes :title
    indexes :desc
    indexes taggings.tag.name, :as => :tag
    indexes department.name, :as => :department, :facet => true
    indexes faculties(:id), :as => :sponsor_id
    indexes faculties(:name), :as => :faculty
    
    has :active
    has :paid
    has :credit
    has :created_at
    has :updated_at
    has :exp_date
    
    set_property :delta => true
  end
  
  def self.active_jobs
    Job.find(:all, :conditions => {:active => true}, :order => "created_at DESC")
  end
  
  def self.smartmatches_for(my, limit=4) # matches for a user
    list_separator = ','        # string that separates items in the stored list
    
    query = []
    [my.course_list_of_user,
     my.category_list_of_user,
     my.proglang_list_of_user].each do |list|
        query.concat list.split(list_separator)
    end
    
    # magic
    smartmatch_ranker = "@weight"
    
    Job.find_jobs(query, {:match_mode=>:any, :limit=>limit, :custom_rank=>smartmatch_ranker, :rank_mode=>:bm25})
  end
  
  # This is the main search handler.
  # It should be the ONLY interface between search queries and jobs;
  # hopefully this will make the choice of search engine transparent
  # to our app.
  #
  # By default, it finds an unlimited number of active and non-expired jobs.
  # You can also restrict by query, department, faculty, paid, credit,
  # and set a limit of max number of results.
  #
  # Currently uses Sphinx/ThinkingSphinx
  #
  # query: Array or string of search terms.
  # extra_options: Hash of additional options:
  #   - exclude_expired: if true, don't include expired jobs
  #   - department: ID of department you want to search, or 0 for all depts
  #   - faculty: ID of faculty member you want to search, or 0 for all
  #   - paid: if true, return jobs that have paid=true; else return paid and nonpaid
  #   - credit: if true, return jobs that have credit=true; else return credit and noncredit
  #   - limit: max. number of results, or 0 for no limit
  #   - match_mode: [:any | :all | :extended], sets match mode. Default :any.
  #   - tags: array of tag strings to match (searches only tags and not body, title, etc.)
  #   - order: ARRAY of custom sorting conditions, besides @relevance. Conditions concatenated left to right.
  #
  def self.find_jobs(query, extra_options={})
    # Sanitize some boolean options to avoid false positives.
    # This happens in situations like paid=0 => paid=true
    [:paid, :credit].each do |attrib|
        extra_options[attrib] = from_binary(extra_options[attrib])
    end
    
    # Handle weird cases with bad query
    query = query.join(' ') if query.kind_of? Array
    
    # Default options
    options = {
        :exclude_expired        => true,
        :paid                   => false,
        :credit                 => false,
        :faculty                => 0,
        :match_mode             => :any,
        :limit                  => 0,
        :tags                   => [],
        :custom_rank            => ""
        }.update(extra_options)

    ts_options = {
        :match_mode     => :any,
        :sort_mode      => :extended,
        :order          => "@relevance DESC, exp_date ASC",
        :rank_mode      => :proximity_bm25
        }
    
    # Selectively build conditions
    ts_conditions = {}
    ts_conditions[:active]      = true
    ts_conditions[:exp_date]    = Time.now..100.years.since unless options[:exclude_expired]
    ts_conditions[:paid]        = true              if options[:paid]
    ts_conditions[:credit]      = true              if options[:credit]
    ts_conditions[:sponsor_id]  = options[:faculty] if options[:faculty] > 0 and Faculty.exists?(options[:faculty])
    ts_conditions[:tag]         = options[:tags]    if not options[:tags].empty?
    
    # Selectively build options
    ts_options[:match_mode]     = options[:match_mode] if [:all, :any, :extended].include? options[:match_mode]
    ts_options[:max_matches]    = options[:limit]   if options[:limit] > 0
    ts_options[:rank_mode]      = options[:rank_mode] if [:proximity_bm25, :bm25, :wordcount].include? options[:rank_mode]
    
    if options[:custom_rank] and not options[:custom_rank].empty?
        ts_options[:sort_mode] = :expr
        ts_options[:order]     = options[:custom_rank]
    end
    
    # Do the search
    if query.nil?
        Job.search nil, {:conditions => ts_conditions}.update(ts_options)
    else
        Job.search query, {:conditions => ts_conditions}.update(ts_options)
    end
    
  end
  
  
  def self.query_url(options)
    params = {}
    params[:query]          = options[:query]               if options[:query]
    params[:department]     = options[:department_id]       if options[:department_id] and Department.exists?(options[:department_id])
    params[:paid]           = true                          if options[:paid]
    params[:credit]         = true                          if options[:credit]
    url_for(:controller => 'jobs', :only_path=>true)+"?#{params.collect { |param, value| param+'='+value }.join('&')}"
  end
   
  def self.find_recently_added(n)
	#Job.find(:all, {:order => "created_at DESC", :limit=>n, :active=>true} )
    Job.find_jobs( :extra_conditions => {:order=>"created_at DESC", :limit=>n} )
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
  
  # Returns the activation url for this job
  def activation_url
    "#{$rm_root}jobs/activate/#{self.id}?a=#{self.activation_code}"
  end
  
  
  # Ensures all fields are valid
  def mend
    # Check for deleted/bad faculty
    if not self.faculties.empty? and not Faculty.exists?(self.faculties.first.id)
        self.faculties = []
    end
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
	
end
