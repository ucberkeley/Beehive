module ApplicationHelper
  # The workhorse filter for authentication.
  # After a controller checks for CAS authentication, 
  # via   'before_filter CASClient::Frameworks::Rails::Filter',
  # this sets up the user via LDAP if 
  # the user does not yet exist, and then creates 
  # the proper UserSession.
  def rm_login_required
    # CASClient::Frameworks::Rails::Filter
    # ^^ already done by calling controller
    logger.warn 'got to rm_login_required'
    logger.warn @user_session.present?.to_s
    redirect_to create_user_session_path
    #if ! @user_session.present? 
     # @user_session = UserSession.new(params[:user_session])
      #if @user_session.save
       # flash[:notice] = "Logged in successfully."
        #@current_user = User.find_by_login(session[:cas_user].to_s)
      #else
      #  flash[:error] = "Couldn't log in. Contact the administrators if this happens again."
      #  redirect_to root_path
      #end
    #end
  end
  
  module NonEmpty
	    def nonempty?
	        not self.nil? and not self.empty?
	    end
	end
end

class String
    include ApplicationHelper::NonEmpty
    
    # Translates \n line breaks to <br />'s.
    def to_br
        self.gsub("\n", "<br />")
    end

    def pluralize_for(n=1)
      n == 1 ? self : self.pluralize
    end
    
end
