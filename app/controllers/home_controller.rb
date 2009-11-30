class HomeController < ApplicationController

	def index
		@departments = Department.all
	end
	
end
