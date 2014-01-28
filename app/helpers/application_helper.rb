# Methods added to this helper will be available to all templates in the application.
include JobsHelper

module ApplicationHelper
  include TagsHelper

  module NonEmpty
      def nonempty?
          not self.nil? and not self.empty?
      end
  end

  def current_user
    # TODO: transition this out in favor of @current_user
    ActiveSupport::Deprecation.warn "current_user is deprecated in favor of @current_user", caller
    @current_user
  end

  def logged_in?
    # TODO: transition out in favor of @current_user
    ActiveSupport::Deprecation.warn "logged_in? is deprecated in favor of @current_user", caller
    !!@current_user
  end

  # Checks if user is logged in as an admin.
  # @return [Boolean] true if {#current_user} is set and is {User#admin?}
  def logged_in_as_admin?
    @current_user and @current_user.admin?
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

end

module ActionView
  module Helpers
    def tag_search_path(tagstring)
      "#{jobs_path}?tags=#{tagstring}"
    end

    ThreeStateLabels = {true=>'Yes', false=>'No', nil=>'N/A'}

    module FormTagHelper
      def indeterminate_check_box_tag(name, value = "1", indeterminate_value = "2", checked = :unchecked, options = {})
        onclick = "this.value=(Number(this.value)+1)%3;this.checked=(this.value==1);this.indeterminate=(this.value==2);"
        check_box_tag(name, value, checked, options.merge({:onclick=>onclick}))
      end


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
  def goto_home_unless_logged_in
    #CASClient::Frameworks::Rails::Filter.filter(self) unless @current_user && @user_session
    redirect_to home_path unless @current_user && @user_session
  end

  def login_user!(user)
    @user_session = UserSession.new(user)
    return @user_session.save
  end

  def rm_login_required
    return true if @current_user
    redirect_to login_path and return false
  end

  def first_login(auth_field, auth_value)
  # Processes a user's first login, which involves creating a new User.
  # Requires a CAS session to be present, and redirects if it isn't.
  # @returns false if redirected because of new user processing, true if user was already signed up
  #

    # Require CAS login first
    unless @user_session
      redirect_to login_path
      return false
    end

    # If user doesn't exist, create it. Use current_user
    # so as to ensure that redirects work properly; i.e.
    # so that you are 'logged in' when you go to the Edit Profile
    # page in this next section here.

    unless User.exists?(auth_field => auth_value)
      new_user = User.new
      new_user[auth_field] = auth_value

      # Implement separate auth provider logic here
      if session[:auth_hash][:provider].to_sym == :cas
        # When using CAS, the Users table is populated from LDAP
        person = new_user.ldap_person
        new_user.email = person.email
        new_user.name = new_user.ldap_person_full_name
        new_user.update_user_type
      end

      if new_user.save && new_user.errors.empty?
        flash[:notice] = "Welcome to ResearchMatch! Since this is your first time here, "
        flash[:notice] << "please verify your email address, #{new_user.name}. We'll send all correspondence to that email address."
        logger.info "First login for #{new_user.login}"

        @current_user = User.where(auth_field => auth_value)[0]
        session[:user_id] = @current_user.id
        redirect_to edit_user_path(@current_user.id)
        return false
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact support."
        flash[:error] += new_user.errors.inspect if Rails.env == 'development'
        redirect_to home_path
        return false
      end
    end

    logger.info("\n\n GOT PAST LOGIN_REQUIRED  \n\n") if Rails.env == 'development'
    return true
  end

  # Redirects to signup page if user hasn't registered.
  # Filter fails if no auth hash is present, or if user was redirected to
  # signup page.
  # Filter passes if auth hash is present, and a user exists.
  def require_signed_up
    return true if session[:auth_hash].present? and User.exists?(:id => session[:user_id])

    redirect_to :controller => :users, :action => :new
    return false
  end

end

