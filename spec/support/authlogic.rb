require 'authlogic/test_case'
include Authlogic::TestCase
activate_authlogic

module LoginHelper

  def disable_cas
    CASClient::Frameworks::Rails.stub!(:Filter).and_return(true)
  end

  # Logs in as the given user
  # @param u [User] user to log in
  # @raise [ArgumentError] if user is missing
  def login_user(u)
    raise ArgumentError.new("User required") unless u
    disable_cas
    UserSession.create(u)
    @current_user = u
  end

  def logout
    if u = UserSession.find
      u.destroy
    end
  end

end

include LoginHelper
