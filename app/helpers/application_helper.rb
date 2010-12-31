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
