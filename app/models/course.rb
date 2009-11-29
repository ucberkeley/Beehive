class Course < ActiveRecord::Base
  has_many :enrollments
  has_many :users, :through => :enrollments
  has_many :coursereqs
  has_many :jobs, :through => :coursereqs
end
