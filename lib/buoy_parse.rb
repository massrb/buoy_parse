require "buoy_parse/version"
require 'hpricot'
require 'open-uri'

class BuoyParse
  
  NOAA_URL_BASE = 'http://www.ndbc.noaa.gov/station_page.php'
  READINGS_TABLE_IDX = 4 # 4th table in html has readings
  
  # labels in NOAA html
  LABEL_MAP = {
    :WDIR => "Wind Direction",
    :WSPD => "Wind Speed",
    :GST => "Wind Gusts",
    :WVHT => "Wave Height",
    :DPD => "Dominant Wave Period",
    :PRES => "Air Pressue",
    :PTDY => "Pressure Tendency",
    :ATMP => "Air Temprature",
    :WTMP => "Water Temprature",
    :SAL => "Salinity",
    :VIS => "Visibility",
    :CHILL => "Wind Chill",
    :MWD => "Mean Wave Direction",
    :DEWP => "Dew Point"
  }
  
  def self.url_for(station_id)
    NOAA_URL_BASE + "?station=#{station_id}";
  end 
  
  def self.parse_station(station_id)
    parse(url_for(station_id.to_s))
  end
  
  def print
    puts
    instance_variables.each do |ivar|
      fld = ivar.to_s.upcase
      fld[0] = '' # remove @ character
      fld = fld.to_sym
      label = LABEL_MAP[fld]
      label = "Time Of Conditions" if !label and fld.eql?(:TIMEOF_CONDITIONS)
      puts  label + ": " + instance_variable_get(ivar).to_s.strip
    end
    puts 
  end
  
  def parse(url)
    hdr = LABEL_MAP.keys.map{|ky| ky.to_s}

    doc = Hpricot(open(url))  #{ |f| Hpricot(f) }
    tidx = 0

    doc.search("/html/body//table").each do |tab|
     
      begin         
        if (mat = /Conditions at \S+ as of.*\((.*)\)/.match(tab.inner_html))
          instance_variable_set("@timeof_conditions",mat[1])
        end
      rescue Exception => e
        puts "Error on parsing time of condition: #{e.message}"
      end
      haveLabel = false
      fldName = "";
      if tidx == READINGS_TABLE_IDX
        (tab/'td').each do |data|
          if haveLabel
            setField(fldName, data.inner_html)
            haveLabel = false
          end
          begin
            if mat = /^.*\(([A-Z]+)\)/.match(data.inner_html)
              # matched a header column of the form
              # <td>Wave Height (WVHT):</td>
              # save the field name if it is a known header value, 
              # the next td element will have the value
              if hdr.any? {|itm| itm == mat[1]}
                haveLabel = true
                fldName = mat[1]
              end
            end
          rescue Exception => e
            puts "Error during parse: #{e.message}"
          end
        end 
      end # if tidx = 4
      tidx += 1
    end # doc.search

  end
  
  # set the instance field to be the same as
  # the header for the most part.
  def setField(fieldName, val)
    fldName = fieldName.downcase
    if fldName == 'wdir'      
     # remove extraneous notes from wind direction field
      if (mat = /(.*)\(.*\)/.match(val))
        val = mat[1]
      end
    end  
    instance_variable_set("@#{fldName}", val.to_s.strip)
    self.class.send(:attr_accessor, fldName)
  end
  
  def self.parse(url)
    rec = self.new
    rec.parse(url)
    rec
  end
  
end
