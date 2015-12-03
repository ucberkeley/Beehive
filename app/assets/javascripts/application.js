//= require jquery
//= require jquery-ui/autocomplete
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require moment
//= require bootstrap
//= require bootstrap-material-design
//= require bootstrap-datepicker
//= require_tree .

$(function() {
  var isMobile = false; 
  // device detection
  if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
    isMobile = true;
  }
  if (!isMobile) {
    /* On desktop, let hover event be equiv to click event for dropdown
       Separation of mouse movement events to prevent flashing hover bug */

    $('.navbar-right .dropdown').mouseenter(function (e) {
      if (!$(this).hasClass('open')) {
        $(this).addClass('open'); 
      }
    });

    $('.navbar-right .dropdown').mouseleave(function (e) {
      if ($(this).hasClass('open')) {
        $(this).removeClass('open'); 
      }
    });
  }
});