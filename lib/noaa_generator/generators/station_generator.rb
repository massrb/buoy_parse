require 'rails/generators'

module Noaa
  module Generators
    class Station < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      argument :reading_model, type: :string, banner: "reading_model"

      self.source_paths << File.join(File.dirname(__FILE__), '../../templates')
      desc "Generates migration for NOAA buoy stations and readings"

      def add_migration
        @station_model = name
        migration_template 'create_noaa_tables.rb', 'db/migrate/create_noaa_tables.rb'
        template 'station_model.rb', "app/models/#{@station_model}.rb"
        template 'reading_model.rb', "app/models/#{reading_model}.rb"
      end

      private
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    end   
  end
end