# BuoyParse

 BuoyParse parses NOAA Buoy websites for recent wave, weather, and marine info.
 This gem uses Hpricot for parsing and at some point should be upgraded to Nokogiri.

 
 Example of an NOAA buoy website for Nantucket:
 http://www.ndbc.noaa.gov/station_page.php?station=44020
 

 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'buoy_parse',  git: 'https://github.com/massrb/buoy_parse.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install buoy_parse -l https://github.com/massrb/buoy_parse.git

## Usage

require 'buoy_parse'

parse Western Maine Shelf buoy:

BuoyParse.parse_station(44030).print
- Time Of Conditions: 7:04 pm EDT
- Wind Direction: NW
- Wind Speed: 23.3 kts
- Wind Gusts: 29.1 kts
- Wave Height: 3.9 ft
- Dominant Wave Period: 4 sec
- Air Pressue: 29.94 in
- Air Temprature: 23.0 &deg;F
- Water Temprature: 37.2 &deg;F
- Salinity: 32.90 psu
- Visibility: 1.6 nmi
- Wind Chill: 6.1 &deg;F

parse Nantucket buoy:

BuoyParse.parse_station(44020).print

- Time Of Conditions: 7:50 pm EDT
- Wind Direction: WNW
- Wind Speed: 17.5 kts
- Wind Gusts: 19.4 kts
- Wave Height: 3.0 ft
- Dominant Wave Period: 4 sec
- Air Pressue: 29.99 in
- Air Temprature: 32.2 &deg;F
- Water Temprature: 34.0 &deg;F
- Wind Chill: 20.1 &deg;F
- Mean Wave Direction: WNW ( 284 deg true )
- Pressure Tendency: +0.07 in ( Rising )
- Dew Point: 10.9 &deg;F


parse Mantauk NY buoy:

BuoyParse.parse_station(44017).print

- Time Of Conditions: 7:50 pm EDT
- Wave Height: 3.0 ft
- Dominant Wave Period: 4 sec
- Mean Wave Direction: W ( 264 deg true )


parse Isle of Shoals Weather Station:

BuoyParse.parse_station('iosn3').print

- Time Of Conditions: 7:00 pm EDT
- Wind Direction: NW
- Wind Speed: 24 kts
- Wind Gusts: 27 kts
- Air Pressue: 29.94 in
- Air Temprature: 22.8 &deg;F
- Wind Chill: 5.7 &deg;F
- Pressure Tendency: +0.05 in ( Rising )
- Dew Point: -4.7 &deg;F

rec = BuoyParse.parse_station('iosn3')
p rec
#<BuoyParse:0x296fb38 @timeof_conditions="8:00 pm EDT on 03/22/2015", @wdir="
 NW ", @wspd="   25 kts", @gst="   29 kts", @pres="29.97 in", @ptdy="+0.08 in (
Rising )", @atmp=" 21.6 &deg;F", @dewp=" -5.1 &deg;F">

puts rec.wdir
NW



## Contributing

1. Fork it ( https://github.com/[my-github-username]/buoy_parse/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
