
require File.expand_path '../buoy_parse.rb', __FILE__

ListPath = File.expand_path '../../buoy_list.txt', __FILE__

module BuoyUtil

  def load_buoys
    self.destroy_all
    buoy_readings_klass.destroy_all

    File.open(ListPath).each do |line|
      puts line
      id = line.strip
      station = parse_station(id)
      next unless station
      puts "#{station.inspect}\n\n"
      puts "#{station.buoy_readings.first.inspect}" if !station.buoy_readings.count.zero?
      puts '-----------------'
      station.save!
      sleep 5
    end
  end

end