$( document ).ready(function() {
  // enable dataTable on campaign#list
  $('#campaigns').dataTable( {
  "sPaginationType": "bootstrap",
  "aoColumnDefs": [ { 'bSortable': false, "aTargets": [ 0, 5 ] } ],
  "iDisplayLength": 25
  });
});