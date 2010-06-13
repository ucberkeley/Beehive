# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	module QueryHelpers
		def as_OR_query
			self.gsub " ", " OR "
		end
	end
	
	module Search
	  def smartmatches_for(my) # matches for a user
		courses = my.course_list_of_user.gsub ",", " "
		cats = my.category_list_of_user.gsub ",", " "
		pls = my.proglang_list_of_user.gsub ",", " "
		query = "#{cats} #{courses} #{pls}"
		#Job.find_by_solr_by_relevance(query)
        find_jobs(query)
	  end

      # This is the main search handler.
      # It should be the ONLY interface between search queries and jobs;
      # hopefully this will make the choice of search engine transparent
      # to our app.
      #
      # Currently uses the simple acts_as_index
      #   (http://douglasfshearer.com/blog/rails-plugin-acts_as_indexed)
      #
      def find_jobs(query)
        #results = Job.find(:all, :conditions => {:active => true }) # TODO: exclude expired jobs too
        results = Job.find_with_index(query, {:conditions => {:active=>true}})
      end
      
	end
end

class String
	include ApplicationHelper::QueryHelpers
end

class ApplicationController
	include ApplicationHelper::Search
end