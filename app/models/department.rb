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
    begin
      Department.all.each do |d|
        define_method d.name.underscore do
          d
        end rescue nil
      end
    rescue => e
    end
  end

  def self.all_departments
    all.collect {|c| [c.name, c.id]}
  end
end
