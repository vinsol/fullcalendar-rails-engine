#FullcalendarEngine

### This engine is made only on Rails 4 apps.

### Installation

Add fullcalendar_engine to your Gemfile:

``` 
gem 'fullcalendar_engine'
```

#### Bundle your dependencies and run the installation generator:
```
bundle
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
    :period => 'Daily|monthly|yearly', 
    :frequency => '4'
})
```

#### In the config directory add the `fullcalendar.yml` and add `mount_path` option in it. Please note that this option is *REQUIRED* and if it is not specified then the JS and CSS of the engine would not work as desired..
```
mount_path: "<path you have mounted your engine on>"
```

The engine can have its own layout, you can add `layout` option to the configuration file. Besides this, all the options which are available with the fullcalendar.js are listed in the *`fullcalendar.yml.dummy`* file.