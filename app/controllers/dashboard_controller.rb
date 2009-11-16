class DashboardController < ApplicationController

  def index
	@departments = Department.all
  end
end
