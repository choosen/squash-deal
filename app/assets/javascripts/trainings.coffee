# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  cd = $(".calendar").attr('id')
  if (cd.length != 0)
    $(".calendar").fullCalendar(
      events: '/users/' + cd.split("_")[1] + '/trainings.json'
    )
  else
    $(".calendar").fullCalendar(
      events: '/trainings.json'
    )
