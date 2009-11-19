class HomeController < ApplicationController
	before_filter :redirect_if_logged_in
	
	def index
		@departments = Department.all
	end
	
	def redirect_if_logged_in
		if logged_in?
			redirect_to :controller=>:dashboard
		end
	end
end
