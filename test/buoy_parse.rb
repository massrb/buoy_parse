require 'minitest/autorun'
require 'open-uri'

# $ ruby test/buoy_parse.rb 

require File.expand_path '../../test_helper.rb', __FILE__

class BuoyParse
  def self.url_for(station_id)
    File.expand_path('../data/station-44030.html', __FILE__)
  end 
end

class BuoyParseTest < Minitest::Test
  def setup
    @parser = BuoyParse
  end

  def test_url_base
    assert_equal @parser::NOAA_URL_BASE, 'http://www.ndbc.noaa.gov/station_page.php'
  end

  def test_parse_buoy
    result = BuoyParse.parse_station(440)
    result.print
    assert_equal result.wvht, '15.1 ft'
    assert_equal result.timeof_conditions, "6:04 pm EDT"
    assert_equal result.wdir, "NNE"
    assert_equal result.wspd, "25.3 kts"
    assert_equal result.gst, "33.0 kts"
    assert_equal result.dpd, "11 sec"
    assert_equal result.pres, "30.00 in"
    assert_equal result.vis, "1.6 nmi"
  end

end