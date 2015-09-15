$(function() {
  if ($('#home-page').length > 0) {
    adjustHomePageHeight();
    $( window ).resize(function() {
      adjustHomePageHeight();
    });
  };
});

function adjustHomePageHeight() {
  console.log($('body').height());
  if($('body').height() > 600) {
    $('.main-bottom').height($('body').height() - 350);
  };
}