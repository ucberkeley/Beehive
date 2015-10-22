'use strict';

// Currently only included in user/edit and jobs/_form
$(function() { 
  // strict autocomplete: exclude entries that are too long or have chars ( ) ; /
  var PURGE_FUZZ = true;
  // Replacement for default autocomplete filter function to search only from the beginning of the string
  function filterStartsWith(array, term) {
    var matcher = new RegExp('^' + $.ui.autocomplete.escapeRegex(term), 'i');
    return $.grep(array, function (value) {
      return matcher.test(value.label || value.value || value);
    });
  }

  function split(val) {
    return val.split(/,\s*/);
  }
  // get the last comma separated value
  function extractLast(term) {
    return split(term).pop();
  }

  /*
   * @param {string}  get_url - JSON URI
   * @param {string}  field_selector - jquery selector of input elem to autocomplete
   * @param {number}  length_limit - limit autocomplete result length to <= this limit
   * @param {boolean} match_begins - if true, limit autocomplete results to startsWith(term)
   */
  function autocomplete_setup(get_url, field_selector, length_limit, match_begins) {
    $.getJSON(get_url, {}, function(data) { 
      $(field_selector).autocomplete({
        minLength: 0,
        maxLength: 6,
        source: function(request, response) {
          var terms;

          if (match_begins) {
            terms = filterStartsWith(data, extractLast(request.term));
          } else {
            terms = $.ui.autocomplete.filter(data, extractLast(request.term));
          }

          if (PURGE_FUZZ) {
            terms = terms.filter(function(item) {
              return !(item.length > length_limit || item.match(new RegExp('[();\/]')));
            });
          }
          
          response(terms.slice(0,12));
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

  autocomplete_setup('/courses/json', '#courses-input', 20, true);
  autocomplete_setup('/categories/json', '#categories-input', 50, false);
  autocomplete_setup('/proglangs/json', '#proglangs-input', 20, true);
});

