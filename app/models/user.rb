class User < ActiveRecord::Base
  # for Authlogic
  acts_as_authentic do |u|
  end

  # User types; used with LDAP  
  class Types
      Undergrad = 0
      Grad      = 1
      Faculty   = 2
      Admin     = 3
      All       = [Undergrad, Grad, Faculty, Admin]
  end
  
  
  # ASSOCIATIONS (abc order)
  has_many :applied_jobs,   :source => 'job', :through => 'applics'
  has_many :attribs,        :through => :job_attribs  # takes care of categories, courses, proglangs (extensible too!)
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
    :in => [Types::Undergrad, Types::Grad, Types::Faculty]  
    # Check that user type is valid
  validates_length_of       :name,     :within => 0..100
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_presence_of     :email, :login, :name
  validates_uniqueness_of   :email, :login

  
  
  # METHODS (abc order)
  
  def can_post?
    [User::Types::Grad, User::Types::Faculty].include? self.user_type
  end
  
  # is_faculty for backward compatibility
  def is_faculty
    self.user_type == User::Types::Faculty
  end
  
end
