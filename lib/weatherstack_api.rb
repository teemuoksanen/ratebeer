class WeatherstackApi
  def self.place(city)
    Rails.cache.fetch("weather_#{city}", expires_in: 1.hour) { get_place(city) }
  end

  def self.get_place(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    return nil if response['success'] == false

    Weather.new(
      name: response['location']['name'],
      temperature: response['current']['temperature'],
      weather_icons: response['current']['weather_icons'],
      wind_speed: response['current']['wind_speed'],
      wind_dir: response['current']['wind_dir']
    )
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end
