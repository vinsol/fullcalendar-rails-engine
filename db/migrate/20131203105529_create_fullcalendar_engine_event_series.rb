class CreateFullcalendarEngineEventSeries < ActiveRecord::Migration
  def change
    create_table :fullcalendar_engine_event_series do |t|
      t.integer :frequency, :default => 1
      t.string :period, :default => 'monthly'
      t.datetime :starttime
      t.datetime :endtime
      t.boolean :all_day, :default => false
      t.timestamps
    end
  end
end
