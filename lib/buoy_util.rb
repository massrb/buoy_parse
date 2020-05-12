
require File.expand_path '../buoy_parse.rb', __FILE__

ListPath = File.expand_path '../../buoy_list.txt', __FILE__

module BuoyUtil

  def setup
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

  def enable_interupts
    @allow_interupt = true
    @enqueued.each { |signal| Process.kill(signal, 0) }
  end

  def load_buoys
    setup
    File.open(ListPath).each do |line|
      puts line
      id = line.strip
      @allow_interupt = false
      station = parse_station(id)
      station.print
      puts '-----------------'
      station.save!
      @allow_interupt = true
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