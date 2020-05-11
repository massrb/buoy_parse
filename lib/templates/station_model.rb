class <%= @station_model.camelize %> < ApplicationRecord
  has_many :<%= reading_model.pluralize %>
end