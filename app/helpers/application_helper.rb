# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	module QueryHelpers
		def as_OR_query
			self.gsub " ", " OR "
		end
	end
	
	module SmartMatch
	  def smartmatches_for(my)
		query = my.course_list_of_user.gsub ",", " "
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