class Faculty < ActiveRecord::Base
	has_many :sponsors
	has_many :jobs, :through => :sponsors
end
