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


    // new BeEF table
    var beef_apikey = $('#beef_apikey').text();

    $('#hooked-browsers-summary-table').dataTable( {
        "sPaginationType": "bootstrap",
        //TODO this must be dynamic, also push new BeEF restful api endpoints
        "sAjaxSource": 'http://172.16.37.1:3000/api/hooks/pf?token=293dd2a040830c1155c9461da85c7eb085d9efbd'
    });
});