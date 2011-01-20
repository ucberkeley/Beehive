# Methods added to this helper will be available to all templates in the application.
include JobsHelper


module ApplicationHelper
	include TagsHelper 
	
	module NonEmpty
	    def nonempty?
	        not self.nil? and not self.empty?
	    end
	end
	
end

module ActionView
  module Helpers
    module FormTagHelper
      def indeterminate_check_box_tag(name, value = "1", indeterminate_value = "2", checked = :unchecked, options = {})
        onclick = "this.value=(Number(this.value)+1)%3;this.checked=(this.value==1);this.indeterminate=(this.value==2);"
        check_box_tag(name, value, checked, options.merge({:onclick=>onclick}))
      end

      ThreeStateLabels = {true=>'Yes', false=>'No', nil=>'N/A'}

      # Select box that maps {true=>1, false=>0, nil=>2}
      def three_state_select_tag(name, value=nil, options={})
        labels = options.delete(:labels) || ThreeStateLabels
        values = options.delete(:values) || {true=>1, false=>0, nil=>2}
        select_tag name, options_for_select([true,false,nil].collect{|k|[labels[k],values[k]]},values[value]), options 
      end
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

class Array
    include ApplicationHelper::NonEmpty
end

class NilClass
    include ApplicationHelper::NonEmpty
end

class Time
    def pp
        self.getlocal.strftime("%b %d, %Y")
    end
end



# Finds value in find_from, and returns the corresponding item from choose_from,
# or default (nil) if find_from does not contain the value.
# Comparisons are done using == and then eql? .
#
# Ex. find_and_choose(["apples", "oranges"], [:red, :orange], "apples")
#        would return :red.
#
def find_and_choose(find_from=[], choose_from=[], value=nil, default=nil)
    find_from.each_index do |i|
        puts "\n\nchecking #{value} == #{find_from[i]}\n"
        return choose_from[i] if find_from[i] == value || find_from[i].eql?(value)
        puts "\n\n\n#{value} wasn't #{find_from[i]}\n\n\n"
    end
    return default
end


# Amazing logic that returns correct booleans.
#
#        n   |  output
#      ------+----------
#        0   |  false
#        1   |  true
#      false |  false
#      true  |  true
#
def from_binary(n)
#      puts "\n\n#{n} => #{n && n!=0}\n\n"
  n && n!=0
end



module CASControllerIncludes
  def goto_cas_unless_logged_in
    CASClient::Frameworks::Rails::Filter.filter(self) unless logged_in?
  end

  def rm_login_required
    #flash[:setjmp] = request.url
  
    # If user doesn't exist, create it. Use current_user
    # so as to ensure that redirects work properly; i.e. 
    # so that you are 'logged in' when you go to the Edit Profile
    # page in this next section here.
    if ! User.exists?(:login => session[:cas_user].to_s)
      new_user = User.new(:login => session[:cas_user].to_s)
      person = new_user.ldap_person
      new_user.email = person.email
      new_user.name = new_user.ldap_person_full_name
      new_user.update_user_type
      
      if new_user.save && new_user.errors.empty? then 
        flash[:notice] = "Looks like this is your first visit to ResearchMatch. "
        flash[:notice] << "Please verify your email address, #{new_user.name}. We'll send all correspondence to that email address."
        
        logger.info "First login for #{new_user.login}"

        self.current_user = User.authenticate_by_login(session[:cas_user].to_s)
        redirect_to :controller => "users", :action => "edit", :id => current_user.id
        return false
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
        redirect_to :controller => "home", :action => "index"
        return false
      end
      
    end
    
    # login_required call handles forcing users to actually login to session
    login_required
    
    logger.info("\n\n\n\n GOT PAST LOGIN_REQUIRED  \n\n\n\n")
  end

  # Redirects to signup page if user hasn't registered.
  # Filter fails if no CAS session is present, or if user was redirected to
  # signup page.
  # Filter passes if CAS session is present, and a user exists.
  def require_signed_up
    return true if session[:cas_user].present? and User.exists?(:login => session[:cas_user])

    redirect_to :controller => :users, :action => :new
    return false
  end

end

