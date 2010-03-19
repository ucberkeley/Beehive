class Faculty < ActiveRecord::Base
	has_many :sponsorships
	has_many :jobs, :through => :sponsorships
	has_many :reviews
end
