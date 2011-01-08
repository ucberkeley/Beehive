# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	include TagsHelper 
	
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
  def cas_unless_logged_in
    CASClient::Frameworks::Rails::Filter.filter(self) unless logged_in?
  end


  # this before_filter takes the results of the rubyCAS-client filter and sets up the current_user, 
  # thereby "logging you in" as the proper user in the ResearchMatch database.
  def setup_cas_user
    return unless session[:cas_user].present?
    @current_user = User.find_by_login(session[:cas_user])
    
    # if user doesn't exist, create it, and then redirect to edit profile page
    if @current_user.blank?

      #TODO: Set user metadata [obtained from LDAP] here, including user_type, rather than all 
      # this fake garbage data!!
      #     (note: the login here is correct; the rest is garbage)
#      @person = UCB::LDAP::Person.find_by_uid(session[:cas_user]) 
#      @current_user = User.new(
#                            :login => session[:cas_user].to_s,
#                            :name => "#{@person.firstname} #{@person.lastname}",
#                            :email => @person.email,
#                            :password => "password", 
#                            :password_confirmation => "password"
#                              ) # necessary to pass validations
                          
      # This has all been moved to users/new.
           
                              
      # @current_user.save!

      #redirect_to :controller => "users", :action => "edit", :id => @current_user.id
      redirect_to :controller => :users, :action => :new
      return false
    end
    
    @current_user.present?
  end

end

