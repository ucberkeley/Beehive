function setupExternalLinks() {
  $('a').each(function(){
    if( this.host && this.host != location.host )
      $(this).attr( 'target', '_blank' );
  });
}

function charcounter( inputElem, counterElem, limit ) {
  var c = $( counterElem );
  var i = $( inputElem );
  var update = function( n ){
    n = n || limit - i.val().length;
    c.text( n + " characters left" );
  };
  var updateCallback = function( event ) {
    if( this.value.length > limit ) {
      this.value = this.value.slice(0,limit);
      update();
      return false;
    }
    update();
  }

  i
   .keydown( updateCallback )
   .keyup  ( updateCallback )
  ;

  $(document).ready(function(){ update(); });
}

function textChange(elementID, defaultText)
{
   var element = $(elementID)

   if(element.value == defaultText)
   {
      element.value = "";
   }
   else if(element.value == "")
   {
      element.value = defaultText;
   }
}

function menu_bar_one(){
	//Menu Bar Button Hover
	$("menu_bar_01").src = "../images/menu_bar_fade_01.png";
	$("menu_bar_01").observe('mouseout', function() {
	  this.src = "../images/menu_bar_fade_01.png";
	});
	$("menu_bar_01").observe('mouseover', function() {
	  this.src = "../images/menu_bar_01.png";
	});

}

function menu_bar_two(){
	//Menu Bar Button Hover
	$("menu_bar_02").src = "../images/menu_bar_fade_02.png";
	$("menu_bar_02").observe('mouseout', function() {
	  this.src = "../images/menu_bar_fade_02.png";
	});
	$("menu_bar_02").observe('mouseover', function() {
	  this.src = "../images/menu_bar_02.png";
	});

}

function menu_bar_three(){
	//Menu Bar Button Hover
	$("menu_bar_03").src = "../images/menu_bar_fade_03.png";
	$("menu_bar_03").observe('mouseout', function() {
	  this.src = "../images/menu_bar_fade_03.png";
	});
	$("menu_bar_03").observe('mouseover', function() {
	  this.src = "../images/menu_bar_03.png";
	});
}

/* users/new signup page sliding effects */

function user_signup_student_fields() {
    $('#fields_student_above_password').slideDown();
    $('#fields_student_below_password').slideDown();
    $('#fields_faculty').slideUp();
}

function user_signup_faculty_fields() {
    $('#fields_student_above_password').slideUp();
    $('#fields_student_below_password').slideUp();
    $('#fields_faculty').slideDown();
}


/* autocomplete endpoint GET requests */
function get_categories() {
    return $.getJSON('/research/categories/json');
}

$(document).ready(function(){
  setupExternalLinks();
});
