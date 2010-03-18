class Faculty < ActiveRecord::Base
	has_many :sponsorships
	has_many :jobs, :through => :sponsorships
	has_and_belongs_to_many :reviews
end
