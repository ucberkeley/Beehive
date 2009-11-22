require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :jobs
  has_many :reviews
  has_one :picture

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
  #validates_format_of		:email,	   :with =>

  before_create :make_activation_code 
  before_validation :handle_email
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation, :faculty_email, :student_email, :is_faculty
  attr_reader :faculty_email; attr_writer :faculty_email;  
  attr_reader :student_email; attr_writer :student_email;
  
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
  puts "\n\n\n\nEMAIL WUZ #{self.email} NAO IZ #{value}\n\n\n\n"
    write_attribute :email, (value && !value.empty? ? value.downcase : self.email)
  end
  
  protected
    

    def make_activation_code
  
      self.activation_code = self.class.make_token
    end

#	def faculty_email; self.email; end
#	def faculty_email=(value); write_attribute :faculty_email, value; end
#	def student_email; self.email; end
#	def student_email=(value); write_attribute :student_email, value; end

	def handle_email
		if self.is_faculty then puts "\n\n\n\nIZ FACULTY\n\n\n\n"
		else puts "\n\n\n\n\nIZ NOT FACULTY\n\n\n\n" end
		puts "\n\n\nFACK #{self.faculty_email} STOOD #{self.student_email}\n\n\n"
		self.email = (self.is_faculty ? self.faculty_email : self.student_email)
#		if self.is_faculty
#			self.email = self.faculty_email
#		else
#			self.email = self.student_email
#		end
	end
	
end
