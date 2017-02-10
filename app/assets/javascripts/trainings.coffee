# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  return unless $(".js-calendar").length > 0
  cdID = $(".js-calendar").attr('id')
  $(".js-calendar").html ''
  if (cdID != undefined)
    $(".js-calendar").fullCalendar(
      events: '/users/' + cdID.split("_")[1] + '/trainings.json'
      timeFormat: 'HH:mm'
      firstDay: 1
      header: {
        left: 'today prev,next'
        center: 'title',
        right: 'month,listYear'
      }
      buttonText: {
        list: 'list year'
      }
    )
  else
    $(".js-calendar").fullCalendar(
      events: '/trainings.json'
      header: {
        left: 'today prev,next',
        center: 'title',
        right: 'month,agendaWeek,agendaDay,listYear'
      },
      timeFormat: 'HH:mm'
      slotLabelFormat: 'HH:mm'
      minTime: '06:00:00'
      maxTime: '23:00:00'
      scrollTime: '08:00:00'
      buttonText: {
        list: 'list year'
      }
      firstDay: 1
    )

$(document).on 'turbolinks:load', ->
  $('.js-datetimepicker').datetimepicker({
    inline: false,
    stepping: 5,
    sideBySide: false,
    format: 'DD.MM.YYYY HH:mm'
    minDate: new Date(),
    # maxDate: new Date().setFullYear(new Date().getFullYear() + 1),
    # keepOpen: false, # not in datetime
    keepInvalid: true,
    focusOnShow: true,
    collapse: true,
    showClose: true, # not @ datetime
  })
