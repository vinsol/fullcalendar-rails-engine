class AddColorToFullcalendarEngineEvent < ActiveRecord::Migration
  def change
    add_column :fullcalendar_engine_events, :color, :string
  end
end
