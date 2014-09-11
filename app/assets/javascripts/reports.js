$( document ).ready(function() {
  $('#victims-table').dataTable( {
  "sAjaxSource": '/reports/uid_json/' + window.location.href.split("/").pop(),
  "sPaginationType": "bootstrap",
  "aLengthMenu": [
      [25, 50, 100, 500, -1],
      [25, 50, 100, 500, "All"]]
  });

  $('#victims-summary-table').dataTable( {
    "sPaginationType": "bootstrap",
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
});