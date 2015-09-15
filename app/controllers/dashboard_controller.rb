class DashboardController < ApplicationController
  include CASControllerIncludes

  before_filter :goto_home_unless_logged_in
  before_filter :rm_login_required

  def index

  end
end
