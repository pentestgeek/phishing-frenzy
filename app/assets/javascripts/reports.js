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
    $('#victims-browsers-summary-table').dataTable( {
        "sPaginationType": "bootstrap",
        //TODO this must be dynamic
        "sAjaxSource": 'http://172.16.37.1:3000/api/hooks?token=2f69a06fde2184e5547eb5b567607c149a19d556',
//        "aoColumnDefs": [
//            {
//                "aTargets": [ 0 ], // Column to target
//                "mRender": function ( data, type, full ) {
//                    // 'full' is the row's data object, and 'data' is this column's data
//                    // e.g. 'full[0]' is the comic id, and 'data' is the comic title
//                    return '<a href="/reports/uid/' + data + '">' + data + '</a>';
//                }
//            }
//        ],
        "columns":[
            { "hooked-browsers.online" : "id"},
            { "hooked-browsers.online" : "name"},
            { "hooked-browsers.online" : "version"},
            { "hooked-browsers.online" : "os"},
            { "hooked-browsers.online" : "platform"},
            { "hooked-browsers.online" : "ip"}
        ],
        "aaSorting": [[4,'desc']],
        "aLengthMenu": [
            [25, 50, 100, 500, -1],
            [25, 50, 100, 500, "All"]]
    } );
});