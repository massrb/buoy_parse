require 'rails/generators'

module Noaa
  module Generators
    class Station < Rails::Generators::NamedBase
      argument :reading_model, type: :string, banner: "reading_model"

      self.source_paths << File.join(File.dirname(__FILE__), '../../templates')
      desc "Generates migration for NOAA buoy stations and readings"

      def add_migration
        @station_model = name
        remove_file 'db/migrate/create_noaa_tables.rb'
        template 'create_noaa_tables.rb', 'db/migrate/create_noaa_tables.rb'
        template 'station_model.rb', "app/models/#{@station_model}.rb"
        template 'reading_model.rb', "app/models/#{reading_model}.rb"
      end
    end   
  end
end