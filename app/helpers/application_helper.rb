module ApplicationHelper
  module NonEmpty
	    def nonempty?
	        not self.nil? and not self.empty?
	    end
	end
end

module ActionView
  module Helpers
    def tag_search_path(tagstring)
      "#{jobs_path}?tags=#{tagstring}"
    end

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
