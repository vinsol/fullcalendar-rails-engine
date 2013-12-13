// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
if (typeof(FullcalendarEngine) === 'undefined') { FullcalendarEngine = {}; }


FullcalendarEngine.Form = {
  display: function(options) {

    if (typeof(options) == 'undefined') { options = {} }
    $('#event_form').trigger('reset');

    var startTime = options['starttime'] || new Date(), endTime = options['endtime'] || new Date(startTime.getTime());

    if(startTime.getTime() == endTime.getTime()) { endTime.setMinutes(startTime.getMinutes() + 15); }

    this.setTime('#event_starttime', startTime)
    this.setTime('#event_endtime', endTime)

    $('#event_all_day').attr('checked', options['allDay'])

    $('#create_event_dialog').dialog({
      title: 'New Event',
      modal: true,
      width: 500,
      close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
    });
  },

  setTime: function(type, time) {
    var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
    $year.val(time.getFullYear());
    $month.prop('selectedIndex', time.getMonth());
    $day.prop('selectedIndex', time.getDate() - 1);
    $hour.prop('selectedIndex', time.getHours());
    $minute.prop('selectedIndex', time.getMinutes());
  }

}

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay + '&authenticity_token=' + authenticity_token,
        dataType: 'script',
        type: 'post',
        url: "fullcalendar_engine/events/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&authenticity_token=' + authenticity_token,
        dataType: 'script',
        type: 'post',
        url: "fullcalendar_engine/events/resize"
    });
}

function showEventDetails(event){
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Edit</a>");
    if (event.recurring) {
        title = event.title + "(Recurring)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")'>Delete All In Series</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")'>Delete All Future Events</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy')
        }
        
    });
    
}


function editEvent(event_id){
    jQuery.ajax({
      url: "fullcalendar_engine/events/" + event_id + "/edit",
      success: function(data) {
        $('#event_desc').html(data['form']);
      } 
    });
}

function deleteEvent(event_id, delete_all){
  jQuery.ajax({
    data: 'authenticity_token=' + authenticity_token + '&delete_all=' + delete_all,
    dataType: 'script',
    type: 'delete',
    url: "fullcalendar_engine/events/" + event_id,
    success: refetch_events_and_close_dialog
  });
}

function refetch_events_and_close_dialog() {
  $('#calendar').fullCalendar( 'refetchEvents' );
  $('.dialog:visible').dialog('destroy');
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }
    
    
    
    
}
$(document).ready(function(){
  $('#create_event_dialog, #desc_dialog').on('submit', "#event_form", function(event) {
    var $spinner = $('.spinner');
    event.preventDefault();
    $.ajax({
      type: "POST",
      data: $(this).serialize(),
      url: $(this).attr('action'),
      beforeSend: show_spinner,
      complete: hide_spinner,
      success: refetch_events_and_close_dialog,
      error: handle_error
    });

    function show_spinner() {
      $spinner.show();
    }

    function hide_spinner() {
      $spinner.hide();
    }

    function handle_error(xhr) {
      alert(xhr.responseText);
    }
  })
});
