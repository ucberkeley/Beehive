class Department < ActiveRecord::Base

  # === List of columns ===
  #   id         : integer 
  #   name       : text 
  #   created_at : datetime 
  #   updated_at : datetime 
  # =======================

  has_many :jobs
  has_many :faculties

  class << self
    # Define methods like ".eecs"
    Department.all.each do |d|
      define_method d.name.underscore do
        d
      end rescue nil
    end
  end

end
