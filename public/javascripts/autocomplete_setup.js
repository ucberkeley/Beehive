


$(function() { 
	function split(val) {
		return val.split(/,\s*/);
	}
	function extractLast(term) {
		return split(term).pop();
	}

    function autocomplete_setup(get_url, field_selector) {
    
        $.getJSON(get_url, {}, function(data, textStatus) { 
            $(field_selector).autocomplete({
		        minLength: 0,
		        maxLength: 6,
		        source: function(request, response) {
			        // delegate back to autocomplete, but extract the last term
			        response($.ui.autocomplete.filter(data, extractLast(request.term)));
		        },
		        focus: function() {
			        // prevent value inserted on focus
			        return false;
		        },
		        select: function(event, ui) {
			        var terms = split( this.value );
			        // remove the current input
			        terms.pop();
			        // add the selected item
			        terms.push( ui.item.value );
			        // add placeholder to get the comma-and-space at the end
			        terms.push("");
			        this.value = terms.join(", ");
			        return false;
		        }
            });
        });
        
        
        
        // get rid of commas on mouse leave
        $(field_selector).focusout(function (){
            fval = $(this).val();
            if (fval && fval.length > 0) {
                if (fval.substring(fval.length - 2, fval.length) === ', ') {
                    $(this).val(fval.substring(0, fval.length - 2));
                }
            }
        });
        
        
    }
    
    autocomplete_setup('/courses/json', '#course_name');
    autocomplete_setup('/categories/json', '#category_name');
    autocomplete_setup('/proglangs/json', '#proglang_name');                
});


