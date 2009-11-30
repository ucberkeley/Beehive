class Proglang < ActiveRecord::Base
	has_many :proglangreqs
	has_many :jobs, :through => :proglangreqs
end
