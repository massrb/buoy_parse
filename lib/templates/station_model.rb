
class <%= @station_model.camelize %> < ApplicationRecord
  extend BuoyUtil
  extend BuoyParse
  has_many :<%= reading_model.pluralize %>

  def buoy_readings_klass
    <%= reading_model.camelize %>
  end

  def buoy_readings
    <%= reading_model.pluralize %>
  end

  def update_readings
    reading_klass = <%= reading_model.camelize %>
    reading = nil
    buoy_readings.each do |read|
      if (read.created_at + 3600) > Time.now
      # reading is still fairly recent
        reading = read
      else 
      # remove old readings
        buoy_readings.delete(read) 
        read.destroy
      end  
    end
    if (!reading)
      reading = reading_klass.new
      reading.parse(url_for(number))
      buoy_readings << reading
    end
  end
end