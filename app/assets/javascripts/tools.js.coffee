# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("[id=download-emails]").tooltip()
  $("[id=show-emails]").tooltip()
  $("[id=delete-emails]").tooltip()
  $("[rel='tooltip']").tooltip();
  return