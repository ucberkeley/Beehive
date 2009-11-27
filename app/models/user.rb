require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :jobs
  has_many :job_inactives
  has_many :reviews
  has_one :picture
  
  has_many :enrollments
  has_many :courses, :through => :enrollments

  #validates_presence_of     :login
  #validates_length_of       :login,    :within => 3..40
  #validates_uniqueness_of   :login
  #validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  # Check that the email address is @*.berkeley.edu or @*.lbl.gov
  validates_format_of		:email,	   :with => /^[^@]+@(?:.+\.)?(?:(?:berkeley\.edu)|(?:lbl\.gov))$/i, :message => "The specified email is not a Berkeley or LBL address."

  before_create :make_activation_code 
  
  # Before carrying out validations (i.e., before actually creating the user object), assign the proper 
  # email address to the user (depending on whether the user is a student or gsi or a faculty) 
  # and handle the courses for the user.
  before_validation :handle_email
  before_validation :handle_name
  before_validation :handle_courses
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation, :faculty_email, :student_email, :is_faculty, :course_names, 
	:student_name, :faculty_name
  attr_reader :faculty_email; attr_writer :faculty_email  
  attr_reader :student_email; attr_writer :student_email
  attr_reader :course_names; attr_writer :course_names
  attr_reader :student_name; attr_writer :student_name
  attr_reader :faculty_name; attr_writer :faculty_name
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  #def login=(value)
  #  write_attribute :login, (value ? value.downcase : nil)
  #end

  def email=(value)
    write_attribute :email, (value && !value.empty? ? value.downcase : self.email)
  end
  
  
  # Returns a string containing the course names taken by user @user
  # e.g. "CS162,CS61A"
  def course_list_of_user
  	course_list = ''
  	courses.each do |course|
  		course_list << course.name + ','
  	end
  	course_list[0..(course_list.length - 2)].upcase
  end

  protected
    

    def make_activation_code
  
      self.activation_code = self.class.make_token
    end

	# Dynamically assign the value of :email, based on whether this user
	# is marked as faculty or not. This should occur as a before_validation
	# since we want to save a value for :email, not :faculty_email or :student_email.
	def handle_email
		self.email = (self.is_faculty ? self.faculty_email : self.student_email)
	end
	
	# Dynamically assign the value of :name, based on whether this user
	# is marked as faculty or not. This should occur as a before_validation
	# since we want to save a value for :name, not :faculty_name or :student_name.
	def handle_name
		self.name = is_faculty ? faculty_name : student_name
	end
	

	# Parses the textbox list of courses from "CS162,CS61A,EE123"
	# etc. to an enumerable object courses
	def handle_courses
		self.courses = []  # eliminates any previous enrollments so as to avoid duplicates
		course_array = []
		course_array = course_names.split(',').uniq if ! course_names.nil?
		course_array.each do |item|
			self.courses << Course.find_by_name(item.upcase.strip)
		end
	end
	

	
end
