# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	include TagsHelper
  
	module QueryHelpers
		def as_OR_query
			self.gsub " ", " OR "
		end
	end
    
end

class String
	include ApplicationHelper::QueryHelpers
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
