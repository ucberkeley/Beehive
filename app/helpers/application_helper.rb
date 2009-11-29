# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	module QueryHelpers
		def as_OR_query
			self.gsub " ", " OR "
		end
	end
end

class String
	include ApplicationHelper::QueryHelpers
end