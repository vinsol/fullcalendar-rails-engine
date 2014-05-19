#FullcalendarEngine

## This engine supports only Rails 4 apps.

### Installation

Add fullcalendar_engine to your Gemfile:

``` 
gem 'fullcalendar_engine'
```

#### Bundle install your dependencies and run the installation generator:
```
bundle install
bundle exec rails g fullcalendar_engine:install
```

#### Declare routes
```
mount FullcalendarEngine::Engine => "/fullcalendar_engine"
```

#### Create Single Event
```
FullcalendarEngine::Event.create({ 
    :title => 'title', 
    :description => 'description', 
    :starttime => Time.current, 
    :endtime => Time.current + 10.minute
})
```

#### Create Event Series
```
FullcalendarEngine::EventSeries.create({ 
    :title => 'title', 
    :description => 'description', 
    :starttime => Time.current,
    :endtime => Time.current + 10.minute, 
    :period => 'daily', 
    :frequency => '4'
})
```

#### In the config directory add the `fullcalendar.yml` and add `mount_path` option in it. Please note that this option is *REQUIRED* and if it is not specified then the JS and CSS of the engine would not work as desired..
```
mount_path: "<path you have mounted your engine on>"
```

The engine can have its own layout, you can add `layout` option to the configuration file. Besides this, all the options which are available with the fullcalendar.js are listed in the *`fullcalendar.yml.dummy`* file.

## Using the Engine in some other views
Initially the engine is designed to work only on the mount point but you can now use this engine anywhere in your app but there is an HTML structure which this engine expects. 

- Create a link or button for the creation of the new events. On its click a modal popup would appear. You can bind the dialog form generation as follows. Assign it any class or id you want.
```
  $('<your-selector>').click(function(event) {
    FullcalendarEngine.Form.display()
    event.preventDefault();
  });
```
- For the calendar events the following HTML code must be copied and pasted directly into your view.
```
  <div>
    <div class="calendar"></div>
  </div>
  <div id = "create_event_dialog" class="dialog" style ="display:none;"></div>
  <div id = "event_desc_dialog" class="dialog" style ="display:none;"></div>
  
  <script type = 'javascript'>
    $('.calendar').fullCalendar(full_calendar_options);
  </script>
```

- The `create_event_dialog` is the container for the dialog form.
- The `event_desc_dialog` is the container for the display of the details of the event.

Credits
-------

[![vinsol.com: Ruby on Rails, iOS and Android developers](http://vinsol.com/vin_logo.png "Ruby on Rails, iOS and Android developers")](http://vinsol.com)

Copyright (c) 2014 [vinsol.com](http://vinsol.com "Ruby on Rails, iOS and Android developers"), released under the New MIT License
