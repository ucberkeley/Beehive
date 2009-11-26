function menu_bar_init(){
	//Menu Bar Button Hover
	$("menu_bar_01").observe('mouseout', function() {
	  this.src = "../images/menu_bar_fade_01.png";
	});
	$("menu_bar_01").observe('mouseover', function() {
	  this.src = "../images/menu_bar_01.png";
	});

	$("menu_bar_02").observe('mouseout', function() {
	  this.src = "../images/menu_bar_fade_02.png";
	});
	$("menu_bar_02").observe('mouseover', function() {
	  this.src = "../images/menu_bar_02.png";
	});

	$("menu_bar_03").observe('mouseout', function() {
	  this.src = "../images/menu_bar_fade_03.png";
	});
	$("menu_bar_03").observe('mouseover', function() {
	  this.src = "../images/menu_bar_03.png";
	});
}
