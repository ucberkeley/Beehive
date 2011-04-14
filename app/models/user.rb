class User < ActiveRecord::Base
  include AttribsHelper

  # for Authlogic
  acts_as_authentic do |u|
  end

  # User types; used with LDAP  
  Types = {
      :undergrad => 0,
      :grad      => 1,
      :faculty   => 2,
      :admin     => 3
  }
  
  
  # ASSOCIATIONS (abc order)
  has_many :applics
  has_many :applied_jobs,   :source => 'job', :through => 'applics'
  has_many :attribs,        :through => :user_attribs  # takes care of categories, courses, proglangs (extensible too!)
  has_many :jobs,           :dependent => :nullify
  #has_one  :resume,      :class_name => 'Document', :conditions => 
    #{:document_type => Document::Types::Resume}, :dependent => :destroy
  #has_one  :transcript,  :class_name => 'Document', :conditions => 
    #{:document_type => Document::Types::Transcript}, :dependent => :destroy
  
  has_many :user_attribs,   :dependent => :destroy # takes care of enrollments, interests, proficiencies
  has_many :watches,        :dependent => :destroy

  # VALIDATIONS (abc order)
  #validates_format_of       :name, ...
  validates_inclusion_of    :user_type, 
    :in => Types.values
    # Check that user type is valid
  validates_length_of       :name,     :within => 0..100
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_presence_of     :email, :login, :name
  validates_uniqueness_of   :email, :login

  # METHODS (abc order)
  def can_post?
    [User::Types[:grad], User::Types[:faculty]].include? self.user_type
  end
  
  def first_login(my_login)
    self.login    = my_login unless my_login.blank?
    self.password = self.password_confirmation = 'password'
    self.name     = ldap_person_full_name
    self.email    = ldap_person.email
    self.update_user_type 
  end

  # Convenience methods
  def is_faculty?
    self.user_type >= User::Types[:faculty]
  end
  def is_undergrad
    return self.user_type == User::Types[:undergrad]
  end

  # Returns the UCB::LDAP::Person for this User
  def ldap_person
    @person ||= UCB::LDAP::Person.find_by_uid(self.login) if self.login
  end

  def ldap_person_full_name
    "#{self.ldap_person.firstname} #{self.ldap_person.lastname}".titleize
  end

  # Updates (but does *NOT* save, by default) this User's role, based on the
  # LDAP information. Raises an error if the user type can't be determined.
  #
  # Options:
  #  - save|update: If true, DO update user type in the database.
  #
  def update_user_type(options={})
    unless options[:stub].blank?   # stub type
      options[:stub] = User::Types[:undergrad] unless User::Types.include?(options[:stub].to_i)
      self.user_type = options[:stub].to_i
    else  # update via LDAP
      person = self.ldap_person
      case   # Determine role
        # Faculty
        when (person.employee_academic? and not person.employee_expired?)
          self.user_type = User::Types[:faculty]

        # Student
        when (person.student? and person.student_registered?)
          case person.berkeleyEduStuUGCode
            when 'G'
              self.user_type = User::Types[:grad]
            when 'U'
              self.user_type = User::Types[:undergrad]
            else
              logger.error "User.update_user_type: Couldn't determine student type for login #{self.login}"
              raise StandardError, "berkeleyEduStuUGCode not accessible. Have you authenticated with LDAP?"
          end # under/grad
        else
          logger.error "User.update_user_type: Couldn't determine user type for login #{self.login}, defaulting to Undergrad"
          #raise StandardError, "couldn't determine user type for login #{self.login}"
          self.user_type = User::Types[:undergrad]
        end # employee/student
    end # stub

    self.update_attribute(:user_type, self.user_type) if options[:save] || options[:update]
    self.user_type
  end # update_user_type

  def user_type_string(options={})
  # Return a string representation of this person's user type
  # Options:
  #  long:      [under]grad => [under]graduate
  #
    s = Types.invert[self.user_type].to_s
    s += 'uate' if options[:long] && [Types[:undergrad], Types[:grad]].include?(self.user_type)
    s = s.titleize
  end
  
  # Returns a list of Jobs this user is watching.
  def watched_jobs
    watched_jobs = []
    self.watches.each do |watch|
      watched_jobs << Job.find(watch.job_id)
    end
    return watched_jobs
  end

end
