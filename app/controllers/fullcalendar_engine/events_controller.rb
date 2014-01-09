require_dependency "fullcalendar_engine/application_controller"

module FullcalendarEngine
  class EventsController < ApplicationController

    layout FullcalendarEngine::Configuration['layout'] || "application"

    before_filter :load_event, :only => [:edit, :update, :destroy, :move, :resize]
    before_filter :determine_event_type, :only => :create

    def create
      if @event.save
        render :nothing => true
      else
        render :text => event.errors.full_messages.to_sentence, :status => 422
      end
    end

    def new
      respond_to do |format|
        format.js
      end
    end

    def get_events
      @events = Event.where("starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'")
      events = []
      @events.each do |event|
        events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring => (event.event_series_id)? true: false}
      end
      render :text => events.to_json
    end

    def move
      if @event
        @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
        @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
        @event.all_day = params[:all_day]
        @event.save
      end
      render :nothing => true
    end

    def resize
      if @event
        @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
        @event.save
      end    
      render :nothing => true
    end

    def edit
      render :json => { :form => render_to_string(:partial => 'edit_form') } 
    end

    def update
      case params[:event][:commit_button]
      when "Update All Occurrence"
        @events = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
        @event.update_events(@events, event_params)
      when "Update All Following Occurrence"
        @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
        @event.update_events(@events, event_params)
      else
        @event.attributes = event_params
        @event.save
      end
      render :nothing => true    
    end  

    def destroy
      case params[:delete_all]
      when "true"
        @event.event_series.destroy
      when "future"
        @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
        @event.event_series.events.delete(@events)  
      else
        @event.destroy
      end
      render :nothing => true
    end

    private

      def load_event
        @event = Event.where(:id => params[:id]).first
      end

      def event_params
        # FIXME: Exception thrown while creating events. Please fix.
        params.require(:event).permit('title', 'description', 'starttime(1i)', 'starttime(2i)', 'starttime(3i)', 'starttime(4i)', 'starttime(5i)', 'endtime(1i)', 'endtime(2i)', 'endtime(3i)', 'endtime(4i)', 'endtime(5i)', 'all_day', 'period', 'frequency', 'commit_button')
      end

      def determine_event_type
        if params[:event][:period] == "Does not repeat"
          @event = Event.new(event_params)
        else
          # @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats], :starttime => param
          @event = EventSeries.new(event_params)
        end
      end

  end
end
