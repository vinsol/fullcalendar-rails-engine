config = File.exists?('config/fullcalendar.yml') ? YAML.load_file("config/fullcalendar.yml") || {} : {}
FullcalendarEngine::Configuration = {
  'editable'    => true,
  'header'      => {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek,agendaDay'
  },
  'defaultView' => 'agendaWeek',
  'height'      => 500,
  'slotMinutes' => 15,
  'dragOpacity' => 0.5,
  'selectable'  => true,
  'timeFormat'  => "h:mm t{ - h:mm t}"
}
FullcalendarEngine::Configuration.merge!(config)
FullcalendarEngine::Configuration['events'] = "#{FullcalendarEngine::Configuration['mount_path']}/events/get_events"
