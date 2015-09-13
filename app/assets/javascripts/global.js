$(function() {
  if ($('#home-page').length > 0) {
    adjustHomePageHeight();
    $( window ).resize(function() {
      adjustHomePageHeight();
    });
  };
});

function adjustHomePageHeight() {
  if($('body').height() > 700) {
    $('.main-bottom').height($('body').height() - 450 + 100);
  };
}