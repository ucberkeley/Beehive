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
  var isMobile = false; //initiate as false
  // device detection
  if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
    isMobile = true;
  }
  if (!isMobile) {
    $('.navbar-right .dropdown').hover(function (e) {
      // On desktop, let hover event be equiv to click event for dropdown
      $('.dropdown-toggle', this).trigger('click'); 
    });
  }
});