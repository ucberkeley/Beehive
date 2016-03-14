class DashboardController < ApplicationController
  include CASControllerIncludes
  before_filter :rm_login_required

  def index

  end
end
