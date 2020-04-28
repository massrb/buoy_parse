require 'minitest/autorun'
require 'rack/test'

# Include our application
$LOAD_PATH.unshift 'lib'
require 'buoy_parse'

# require File.expand_path ‘../../app.rb’, __FILE__ # Sinatra App