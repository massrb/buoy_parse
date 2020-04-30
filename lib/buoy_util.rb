
require File.expand_path '../buoy_parse.rb', __FILE__

ListPath = File.expand_path '../../buoy_list.txt', __FILE__

class BuoyUtil

  def self.setup
    @allow_interupt = true
    @enqueued     = [ ]
    trap 'SIGINT' do
      if @allow_interupt
        puts 'Exiting'
        exit 130
      else
        puts 'ignore ctl-c'
        @enqueued.push(signal)
      end
    end
  end

  def save_results

  end

  def self.enable_interupts
    @allow_interupt = true
    @enqueued.each { |signal| Process.kill(signal, 0) }
  end

  def self.build_yaml_file
    @map = {}
    setup
    File.open(ListPath).each do |line|
      puts line
      id = line.strip
      station = BuoyParse.parse_station(id)
      station.print
      puts '-----------------'
      @map[id] = station.to_hash
      puts @map[id].inspect
      sleep 5
    end
    puts 'stubbed, no interupt'
    @allow_interupt = false
    sleep 10
    puts 'allow'
    enable_interupts
    sleep 90
  end

end