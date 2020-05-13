require "buoy_parse/version"
require "noaa_generator/generators/station_generator"
require 'buoy_util'

require 'nokogiri'
require 'open-uri'


module BuoyParse

  READINGS_TABLE_IDX = 4 # 4th table in html has readings
  
  # labels in NOAA html
  LABEL_MAP = {
    WDIR: "Wind Direction",
    WSPD: "Wind Speed",
    GST: "Wind Gusts",
    WVHT: "Wave Height",
    DPD: "Dominant Wave Period",
    PRES: "Air Pressue",
    PTDY: "Pressure Tendency", 
    ATMP: "Air Temprature",
    WTMP: "Water Temprature",
    SAL: "Salinity",
    VIS:  "Visibility",
    CHILL: "Wind Chill",
    MWD: "Mean Wave Direction",
    # DEWP: "Dew Point"
  }
  
  NOAA_URL_BASE = 'http://www.ndbc.noaa.gov/station_page.php'

  def url_for(station_id)
    NOAA_URL_BASE + "?station=#{station_id}";
  end


  def parse_station(station_id)
    parse(url_for(station_id.to_s))
  end

  def parse(url)
    rec = self.new
    rec.extend ParseModule
    rec.parse(url)
    rec
  end

  # this module could be included either by an active record class
  # or the ReadingParser class. In the later case it can work outside 
  # of the rails environment
  module ParseModule
  
    def with_fields
      @record.instance_variables.each do |ivar|
        fld = ivar.to_s.upcase
        fld[0] = '' # remove @ character
        fld = fld.to_sym
        label = LABEL_MAP[fld]
        label = "Time Of Conditions" if !label and fld.eql?(:TIMEOF_CONDITIONS)
        label ||= fld.to_s.capitalize
        next if ['Association_cache'].include? label
        yield label, instance_variable_get(ivar).to_s.strip
      end
    end

    def print
      puts '---------'
      with_fields do |label, val|
         puts "#{label}: #{val}"
      end
      puts
    end

    def to_hash
      hash = {}
      with_fields do |label, val|
        hash[label] = val
      end
      hash
    end

    def parse(url)
      @hdr = LABEL_MAP.keys.map{|ky| ky.to_s}
      @doc = Nokogiri::HTML(open(url))
      @record = self
      @fld_count = 0
      if @record.attributes['description'].to_s.strip.empty?
        parse_station
      end
      
      if buoy_readings.count.zero? 
        @record = buoy_readings_klass.new
        parse_readings
        buoy_readings << @record if @fld_count > 0
        puts "record:#{@record.inspect}\n\n"  if @fld_count > 0
      end  
    end

    private

    def parse_station
      desc = @doc.at("meta[name='description']")['content']
      if desc
        desc.sub!("National Data Buoy Center - Recent observations from",'')
        desc.strip!
        setField('description', desc)
        if desc =~ /\((\S+)\s+(\S+)\)/
          location = [$1, $2]
          if location.all?{ |n| n =~ /\d+\.\d+[[:alpha:]]/ || n =~ /\d+[[:alpha:]]/ }
            setField('latitude', location[0])
            setField('longitude', location[1])
          end
        end
        @record.save!
      end
    end

    def parse_readings
      @fld_count = 0
      tidx = 0
      @doc.search("/html/body//table").each do |tab|
        begin         
          if (mat = /Conditions at \S+ as of.*\((.*)\)/.match(tab.inner_html))
            setField('timeof_conditions', mat[1])
          end
        rescue Exception => e
          puts "Error on parsing time of condition: #{e.message}"
        end
        have_label = false
        fld_name = "";
        if tidx == READINGS_TABLE_IDX
          (tab/'td').each do |data|
            if have_label
              setField(fld_name, data.inner_html)
              have_label = false
            end
            begin
              if mat = /^.*\(([A-Z]+)\)/.match(data.inner_html)
                # matched a header column of the form
                # <td>Wave Height (WVHT):</td>
                # save the field name if it is a known header value, 
                # the next td element will have the value
                if @hdr.any? { |itm| itm == mat[1] }
                  have_label = true
                  fld_name = mat[1]
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
    def setField(field_name, val)
      fld_name = field_name.downcase
      if fld_name == 'wdir'
        # remove extraneous notes from wind direction field
        if (mat = /(.*)\(.*\)/.match(val))
          val = mat[1]
        end
      end
      #instance_variable_set("@#{fld_name}", val.to_s.strip)
      if @record.respond_to? :update_attribute
        # active record
        @fld_count += 1
        @record.update_attribute fld_name, val.to_s.strip
      else  
        self.class.send(:attr_accessor, fld_name)
      end
    end
  end

end
