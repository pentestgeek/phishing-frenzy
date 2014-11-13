$( document ).ready(function() {
  $('#victims-table').dataTable( {
  "sAjaxSource": '/reports/uid_json/' + window.location.href.split("/").pop(),
  "aLengthMenu": [
      [25, 50, 100, 500, -1],
      [25, 50, 100, 500, "All"]]
  });

  $('#victims-summary-table').dataTable( {
    "sAjaxSource": '/reports/victims_list/' + window.location.href.split("=").pop(),
    "aoColumnDefs": [
    {
     "aTargets": [ 0 ], // Column to target
     "mRender": function ( data, type, full ) {
        // 'full' is the row's data object, and 'data' is this column's data
        // e.g. 'full[0]' is the comic id, and 'data' is the comic title
        return '<a href="/reports/uid/' + data + '">' + data + '</a>';
      }
    }
  ],
  "aaSorting": [[4,'desc']],
  "aLengthMenu": [
      [25, 50, 100, 500, -1],
      [25, 50, 100, 500, "All"]]
  } );

  // datatable for reports#list launched campaigns
  $('#launched-campains').dataTable({
    "iDisplayLength": 25
  });
});