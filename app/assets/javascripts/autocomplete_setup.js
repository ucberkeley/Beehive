'use strict';

// Currently only included in user/edit.html.haml
$(function() { 
  // strict autocomplete: exclude entries that are too long or have chars ( ) ; /
  var PURGE_FUZZ = true;

  function split(val) {
    return val.split(/,\s*/);
  }
  // get the last comma separated value
  function extractLast(term) {
    return split(term).pop();
  }
  function autocomplete_setup(get_url, field_selector, length_limit) {

    $.getJSON(get_url, {}, function(data) { 
      $(field_selector).autocomplete({
        minLength: 0,
        maxLength: 6,
        source: function(request, response) {
          // delegate back to autocomplete, but extract the last term
          if (PURGE_FUZZ) {
            var terms = $.ui.autocomplete.filter(data, extractLast(request.term));
            response(terms.filter(function(item) {
              return !(item.length > length_limit || item.match(new RegExp('[\(\);\/]')));
            }));
          } else {
            response($.ui.autocomplete.filter(data, extractLast(request.term)));
          }
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
          terms.push('');
          this.value = terms.join(', ');
          return false;
        }
      });
    });

    // get rid of commas on mouse leave
    $(field_selector).focusout(function () {
      var fval = $(this).val();
      if (fval && fval.length > 0) {
        if (fval.substring(fval.length - 2, fval.length) === ', ') {
          $(this).val(fval.substring(0, fval.length - 2));
        }
      }
    });
  }

  autocomplete_setup('/courses/json', '#courses-input', 20);
  autocomplete_setup('/categories/json', '#categories-input', 50);
  autocomplete_setup('/proglangs/json', '#proglangs-input', 20);
});

