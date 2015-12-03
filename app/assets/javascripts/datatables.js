//https://www.datatables.net/plug-ins/sorting/datetime-moment
$.fn.dataTable.moment = function (format, locale) {
    var types = $.fn.dataTable.ext.type;
    types.detect.unshift(function (d) {
      if (d && d.replace) {
          d = d.replace(/<.*?>/g, '');
      }
      if (d === '' || d === null) {
          return 'moment-' + format;
      }
      return moment(d, format, locale, true).isValid() ? 'moment-' + format : null;
    });
    types.order['moment-' + format + '-pre'] = function (d) {
      return d === '' || d === null ? -Infinity : parseInt(moment(d.replace ? d.replace(/<.*?>/g, '') : d, format, locale, true).format('x'), 10);
    };
  };

//Based on https://datatables.net/examples/plug-ins/sorting_manual.html
$.fn.dataTable.ext.type.order['status-pre'] = function (d) {
  switch (d) {
    case 'Accepted': return 1;
    case 'Undecided': return 2;
    case 'Not accepted': return 3;
  }
  return 0;
};

$.fn.dataTable.moment('MMMM D, YYYY');
$(document).ready(function(){
  $('.job_table').each(function(index, elem) {
    $(elem).DataTable({
      searching: false,
      paging: false,
      columnDefs: [{targets: 0, orderData: [0, 3]}, {targets: 1, orderData: [1, 3]}, {targets: 2, orderData: [2, 3]}, {targets: 3, orderData: [3, 0], type: "status"}]
    });
  });
});
