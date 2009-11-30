# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	module QueryHelpers
		def as_OR_query
			self.gsub " ", " OR "
		end
	end
	
	module SmartMatch
	  def smartmatches_for(my)
		courses = my.course_list_of_user.gsub ",", " "
		cats = my.category_list_of_user.gsub ",", " "
		pls = my.proglang_list_of_user.gsub ",", " "
		query = "#{cats} #{courses} #{pls}"
		Job.find_by_solr_by_relevance(query)
	  end
	end

end

class String
	include ApplicationHelper::QueryHelpers
end

class ApplicationController
	include ApplicationHelper::SmartMatch
end