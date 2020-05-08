
class CreateNoaaTables < ActiveRecord::Migration
  def self.up

    create_table :noaa_stations do |t|
      t.column :number, :string, :limit => 30
      t.column :name, :string, :limit => 40
      t.column :area, :string, :limit => 2
      t.column :weight, :string, :limit => 2
      t.column :geo_location, :string
      t.timestamps
    end


    create_table :readings do |t|
      t.column :noaa_station_id, :integer
      t.column :wdir, :string, :limit => 20
      t.column :wspd, :string, :limit => 20
      t.column :wvht, :string, :limit => 20
      t.column :dpd, :string, :limit => 20
      t.column :apd, :string, :limit => 20
      t.column :pres, :string, :limit => 20
      t.column :ptdy, :string, :limit => 20
      t.column :atmp, :string, :limit => 20
      t.column :wtmp, :string, :limit => 20
      t.column :mwd, :string, :limit => 20
      t.column :timeof_conditions, :string, :limit => 35
      t.timestamps
    end

  end


  def self.down
    drop_table :noaa_stations
    drop_table :noaa_readings
  end
end
