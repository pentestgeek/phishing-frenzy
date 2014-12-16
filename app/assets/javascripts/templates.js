//= require codemirror
//= require codemirror
//= require codemirror/modes/xml
//= require codemirror/modes/htmlmixed
//= require codemirror/modes/javascript
//= require codemirror/modes/ruby

$( document ).ready(function() {
  // enable dataTable on templates#list
  $('#templates').dataTable( {
  "aoColumnDefs": [ { 'bSortable': false, "aTargets": [ 0, 4 ] } ],
  "iDisplayLength": 25
  });

$('#attachment_content').each(function() {
         var editor = CodeMirror.fromTextArea(this, {
             viewportMargin: Infinity,
             lineNumbers : true,
             matchBrackets : true
         });
     })
});