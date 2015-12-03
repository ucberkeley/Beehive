'use strict';

$(function() {
  var filter_box = $('#advanced_search .card.card-x');
  var body = $('body');

  $(window).on('scroll', function() {
    if (document.body.scrollTop > 300) {
      filter_box.addClass('fix');
    } else {
      filter_box.removeClass('fix');
    }
  });
});