$(function() {
  $('#do-job-search').on('click', function(e) {
    e.preventDefault();
    var params = {
      'compensation': $('#compensation').val(),
      'department': $('#department').val(),
      'per_page': $('#per_page').val(),
      'query': $('#query').val()
    }
    var url = '/jobs/search?' + $.param(params)
    window.location.replace(url);
  })
})

$(function() {
  $('#do-job-filter').on('click', function(e) {
    e.preventDefault();
    var params = {
      'compensation': $('#compensation').val(),
      'department': $('#department').val(),
      'per_page': $('#per_page').val(),
      'query': $('#query').val()
    }
    var url = '/jobs/search?' + $.param(params)
    window.location.replace(url);
  })
})
