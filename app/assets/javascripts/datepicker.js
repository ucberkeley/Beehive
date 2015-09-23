$(function() {
  $('.datepicker').each(function(index, elem) {
    $(elem).datepicker({
      format: 'yyyy-mm-dd',
    });
  });
})