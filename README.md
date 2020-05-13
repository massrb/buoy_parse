# BuoyParse

 BuoyParse parses NOAA Buoy websites for recent wave, weather, and marine info.
 This gem uses Nokogiri. It is in a state of work in progress and changes from older
 implementations
 
 Example of an NOAA buoy website for Nantucket:
 http://www.ndbc.noaa.gov/station_page.php?station=44020
 

 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'buoy_parse',  git: 'https://github.com/massrb/buoy_parse.git'
```

And then execute:

    $ bundle


## Usage


```rails

rails generator noaa:station noaa_station noaa_reading

rails c

irb(main):001:0> NoaaStation.load_buoys



## Contributing

1. Fork it ( https://github.com/[my-github-username]/buoy_parse/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
