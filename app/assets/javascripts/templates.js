$( document ).ready(function() {
  // enable dataTable on templates#list
  $('#templates').dataTable( {
  "aoColumnDefs": [ { 'bSortable': false, "aTargets": [ 0, 4 ] } ],
  "iDisplayLength": 25
  });
});