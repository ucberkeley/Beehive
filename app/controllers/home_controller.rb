class HomeController < ApplicationController
  def index
    @departments = Department.all
    @current_user = current_user
  end
end
