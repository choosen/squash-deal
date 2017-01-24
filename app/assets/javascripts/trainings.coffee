# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  return unless $(".calendar").length > 0
  cdID = $(".calendar").attr('id')
  $(".calendar").html ''
  if (cd != undefined)
    $(".calendar").fullCalendar(
      events: '/users/' + cdID.split("_")[1] + '/trainings.json'
    )
  else
    $(".calendar").fullCalendar(
      events: '/trainings.json'
    )
