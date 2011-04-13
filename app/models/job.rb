class Job < ActiveRecord::Base
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
  validate :expiration_date_cannot_be_in_the_past
  #validate :must_have_sponsor  #, :unless => Proc.new{|j|j.skip_validate_sponsorships}
  validates_length_of :title, :within => 10..200
  validates_numericality_of :num_positions, :allow_nil => true
  validates_presence_of :department, :desc, :title 

  # CUSTOM VALIDATION METHODS
  
  # Validates that expiration dates are no earlier than right now.
  def expiration_date_cannot_be_in_the_past
    errors[:expiration_date] << "cannot be earlier than now" if 
      !exp_date.blank? and exp_date < Time.now - 1.hour
  end

  def must_have_sponsor
    errors[:base] << ("Job posting must have at least one faculty sponsor.") unless (sponsorships.size > 0)
  end

  # SCOPES
  scope :active, where(:active => true)
  
  # OTHER METHODS (abc order)
  
  # Sets the faculty specified by the given id
  # as this job's sponsor.
  def handle_sponsorships(faculty_id)
    self.sponsorships = []
    self.faculties = []
    self.faculties << Faculty.find_by_id(faculty_id)
  end
    
  
end
