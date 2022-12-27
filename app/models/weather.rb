class Weather < OpenStruct
  def self.rendered_fields
    [:name, :temperature, :weather_icons, :wind_speed, :wind_dir]
  end
end
