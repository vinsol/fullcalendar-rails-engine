require_dependency 'fullcalendar_engine/application_controller'

module FullcalendarEngine
  class EventsController < ApplicationController

    layout FullcalendarEngine::Configuration['layout'] || 'application'

    before_filter :load_event, only: [:edit, :update, :destroy, :move, :resize]
    before_filter :determine_event_type, only: :create

    def create
      if @event.save
        render nothing: true
      else
        render text: @event.errors.full_messages.to_sentence, status: 422
      end
    end

    def new
      respond_to do |format|
        format.js
      end
    end

    def get_events
      start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
      end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)

      @events = Event.where('
                  (starttime >= :start_time and endtime <= :end_time) or
                  (starttime >= :start_time and endtime > :end_time and starttime <= :end_time) or
                  (starttime <= :start_time and endtime >= :start_time and endtime <= :end_time) or
                  (starttime <= :start_time and endtime > :end_time)',
                  start_time: start_time, end_time: end_time)
      events = []
      @events.each do |event|
        events << { id: event.id,
                    title: event.title,
                    description: event.description || '', 
                    start: event.starttime.iso8601,
                    end: event.endtime.iso8601,
                    allDay: event.all_day,
                    recurring: (event.event_series_id) ? true : false }
      end
      render json: events.to_json
    end

    def move
      if @event
        @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
        @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
        @event.all_day   = params[:all_day]
        @event.save
      end
      render nothing: true
    end

    def resize
      if @event
        @event.endtime = make_time_from_minute_and_day_delta(@event.endtime)
        @event.save
      end    
      render nothing: true
    end

    def edit
      render json: { form: render_to_string(partial: 'edit_form') } 
    end

    def update
      case params[:event][:commit_button]
      when 'Update All Occurrence'
        @events = @event.event_series.events
        @event.update_events(@events, event_params)
      when 'Update All Following Occurrence'
        @events = @event.event_series.events.where('starttime > :start_time', 
                                                   start_time: @event.starttime.to_formatted_s(:db)).to_a
        @event.update_events(@events, event_params)
      else
        @event.attributes = event_params
        @event.save
      end
      render nothing: true
    end

    def destroy
      case params[:delete_all]
      when 'true'
        @event.event_series.destroy
      when 'future'
        @events = @event.event_series.events.where('starttime > :start_time',
                                                   start_time: @event.starttime.to_formatted_s(:db)).to_a
        @event.event_series.events.delete(@events)
      else
        @event.destroy
      end
      render nothing: true
    end

    private

    def load_event
      @event = Event.where(:id => params[:id]).first
      unless @event
        render json: { message: "Event Not Found.."}, status: 404 and return
      end
    end

    def event_params
      params.require(:event).permit('title', 'description', 'starttime', 'endtime', 'all_day', 'period', 'frequency', 'commit_button')
    end

    def determine_event_type
      if params[:event][:period] == "Does not repeat"
        @event = Event.new(event_params)
      else
        @event = EventSeries.new(event_params)
      end
    end

    def make_time_from_minute_and_day_delta(event_time)
      params[:minute_delta].to_i.minutes.from_now((params[:day_delta].to_i).days.from_now(event_time))
    end
  end
end
