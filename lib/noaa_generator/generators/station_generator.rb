require 'rails/generators'

module NoaaGenerator
  module Generators
    class StationGenerator < Rails::Generators::Base
      self.source_paths << File.join(File.dirname(__FILE__), '../../templates')
      desc "Generates migration for NOAA buoy stations and readings"

      def add_migration
        remove_file 'db/migrate/create_noaa_tables.rb'
        copy_file 'create_noaa_tables.rb', 'db/migrate/create_noaa_tables.rb'
      end
    end   
  end
end