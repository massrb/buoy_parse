class <%= reading_model.camelize %> < ApplicationRecord
  belongs_to :<%= @station_model %>
end