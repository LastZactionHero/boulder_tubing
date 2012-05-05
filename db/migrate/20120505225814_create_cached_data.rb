class CreateCachedData < ActiveRecord::Migration
  def change
    create_table :cached_data do |t|
      t.float :cfs
      t.float :current_temperature
      t.string :current_condition
      t.float :today_high
      t.string :today_condition
      t.datetime :cache_time

      t.timestamps
    end
  end
end
