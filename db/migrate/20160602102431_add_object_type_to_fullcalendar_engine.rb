class AddObjectTypeToFullcalendarEngineEvents < ActiveRecord::Migration
  def change
    add_column :fullcalendar_engine_events, :object_type, :string
  end
end
