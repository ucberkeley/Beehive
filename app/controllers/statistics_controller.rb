class StatisticsController < ApplicationController

  before_filter :goto_home_unless_logged_in

  def index
    applics_this_month = Applic.where("created_at >= ?", Time.now.beginning_of_month) 
    applics_in_last_month = Applic.where("created_at >= ?", Time.now - 1.month) 
    @num_applics_this_month = applics_this_month.size
    @num_applics_in_last_month = applics_in_last_month.size
  end
end
