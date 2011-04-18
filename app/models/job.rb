class Job < ActiveRecord::Base

  # === List of columns ===
  #   id                  : integer 
  #   user_id             : integer 
  #   title               : string 
  #   desc                : text 
  #   num_positions       : integer 
  #   department_id       : integer 
  #   activation_code     : string 
  #   active              : boolean 
  #   created_at          : datetime 
  #   updated_at          : datetime 
  #   delta               : boolean 
  #   earliest_start_date : datetime 
  #   latest_start_date   : datetime 
  #   end_date            : datetime 
  #   open_ended_end_date : boolean 
  #   paid                : boolean 
  #   credit              : boolean 
  # =======================

  include AttribsHelper
  
  # ASSOCIATIONS (abc order)
  belongs_to :department
  belongs_to :user  # who posted the job

  has_many :applics 
  has_many :applicants, :source => :user, :through => :applics

  has_many :attribs, :through => :job_attribs     # takes care of categories, courses, proglangs (extensible too!)
  has_many :faculties, :through => :sponsorships
  has_many :job_attribs, :dependent => :destroy # takes care of category_fields, coursereqs, proglangreqs
  has_many :sponsorships, :dependent => :destroy
  has_many :watchers, :source => :user, :through => :watches
  has_many :watches

  # VALIDATIONS  (abc order)
  #   (May require extra work to deal with sponsorships and other 
  #    data when dealing with job activations)
  validate :end_date_cannot_be_in_the_past
  validate :latest_start_date_must_be_before_earliest
  #validate :must_have_sponsor  #, :unless => Proc.new{|j|j.skip_validate_sponsorships}
  validates_length_of :title, :within => 10..200
  validates_numericality_of :num_positions, :allow_nil => true
  validates_presence_of :department, :desc, :title 

  # CUSTOM VALIDATION METHODS
  
  # Validates that end dates are no earlier than right now.
  def end_date_cannot_be_in_the_past
    errors[:end_date] << "cannot be earlier than now" if 
      !end_date.blank? and end_date < Time.now - 1.hour
  end

  def latest_start_date_must_be_before_earliest
    errors[:latest_start_date] << "cannot be earlier than the earliest start date" if 
      !latest_start_date.blank? and latest_start_date < earliest_start_date
  end

  def must_have_sponsor
    errors[:base] << ("Job posting must have at least one faculty sponsor.") unless (sponsorships.size > 0)
  end

  # ThinkingSphinx search
  define_index do
    # Job texts
    indexes :title
    indexes :desc

    # Job attributes
    has end_date
    has :active
    has num_positions

    # Foreign keys
    indexes faculties(:name), :as => :sponsors, :facet => true
    has     faculties(:id),   :as => :faculty_ids
    has     department(:id),  :as => :department_id

    indexes attribs.value,  :as => :attribs,  :facet => true

    # Sphinx properties
    set_property :delta => true
  end

  # Delta indexing
  before_save   :set_delta
  before_update :set_delta
  private
  def set_delta
    self.delta = true
  end
  public

  # SCOPES
  scope :active, where(:active => true)
  
  # OTHER METHODS (abc order)
  
  # Returns true if the specified user has admin rights (can view applications,
  # edit, etc.) for this job.
  def allow_admin_by?(u)
    self.user == u or self.faculties.include?(u)
  end
  
  # Sets the faculty specified by the given id
  # as this job's sponsor.
  def handle_sponsorships(faculty_id)
    self.sponsorships = []
    self.faculties = []
    self.faculties << Faculty.find_by_id(faculty_id)
  end

  def self.search_jobs(query, options)
  # Main job search function (can't call it 'search' b/c that conflicts with ThinkingSphinx...)
  # Query is a string of keywords to search
  # Options can include:
  #   faculty_id:       Restrict results to specific faculty
  #   department_id:    Restrict results to specific department
  #
    # Sanitize input
    query ||= ""
    query.gsub! /[^a-zA-z0-9]/, ''

    ts_options = {:conditions=>{}, :with=>{}} #Hash.new{|h,k|h[k]={}}

    ################
    # phase 1: ALL #
    ################
    ts_options[:with][:active]        = true
    ts_options[:with][:faculty_ids]   = options.delete(:faculty_id).to_i if options[:faculty_id].present?
    ts_options[:with][:department_id] = options.delete(:department_id).to_i if options[:department_id].present?

    ts_options[:match_mode] = :all

    # Get results
    results = Job.search ts_options

    ################
    # phase 2: ANY #
    ################
    ts_options = {:conditions => {}, :with => {}}
    results = results.search query, ts_options

  end # search

   
  
end
