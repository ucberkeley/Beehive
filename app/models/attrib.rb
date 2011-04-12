class Attrib < ActiveRecord::Base
  # constant: list of permitted and used attrib names (singular)
  ATTRIB_NAMES = ['interest category', 'course', 'programming language', 'desired skill']
  
  def self.get_attrib_names
    ATTRIB_NAMES
  end
end
