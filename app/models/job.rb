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
  #validate :must_have_sponsor     #, :unless => Proc.new{|j|j.skip_validate_sponsorships}
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
  
  # HELPER METHODS
  
  # Helper method invoked by JobController's update and
  # create. Updates the attribs of the job with the
  # stuff in params.
  def update_attribs(params)
    
    # Attribs logic. Gets the attribs from the params and finds or 
    # creates them appropriately.

    self.attribs = []
    
    Attrib.get_attrib_names.each do |attrib_name|

      # What was typed into the box. May include commas and spaces.
      raw_attrib_value = params['attrib_' + attrib_name]
      
      # If left blank, we don't want to create "" attribs.
      if raw_attrib_value.present?
        raw_attrib_value.split(',').uniq.each do |val_before_fmt|
          
          # Avoid ", , , ," situations
          if val_before_fmt.present?
            
            # Remove leading/trailing whitespace
            val = val_before_fmt.strip
            
            # HACK: We want to remove spaces and use uppercase for courses only
            if attrib_name == 'course'
              val = val.upcase.gsub(/ /, '')
            else
              val = val.downcase
            end
            
            the_attrib = Attrib.find_or_create_by_name_and_value(attrib_name, val)
            self.attribs << the_attrib

          end
        end
      end
    end
    
  end
end
