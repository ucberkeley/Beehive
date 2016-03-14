# Methods added to this helper will be available to all templates in the application.
include JobsHelper

module ApplicationHelper
  # include TagsHelper

  module NonEmpty
      def nonempty?
          not self.nil? and not self.empty?
      end
  end

  # Checks if user is logged in as an admin.
  # @return [Boolean] true if {#current_user} is set and is {User#admin?}
  def logged_in_as_admin?
    @current_user and @current_user.admin?
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  def email_regex
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end

  # TODO merge with job.can_admin?
  # TODO faculties cannot be compared with user
  def can_view_apps(user, job)
    user.present? && (job.contacter == user || job.sponsorships.include?(user) ||
                      job.owners.include?(user) || job.faculties.include?(user))
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
  def rm_login_required
    remember_location
    return true if @current_user && @user_session
    (redirect_to login_path) and false
  end
end
