class AddObjectIdToFullcalendarEngineEvents < ActiveRecord::Migration
  def change
    add_column :fullcalendar_engine_events, :object_id, :integer
  end
end
