module WeatherHelper
  
  def self.weather_info
    info = Weather.run(:location => "Leipzig")
    data = info.parse
    #"#{info.first.celsius_high}"
    <<-HTML
      <div>
        <img src="http://google.com/#{data.first.icon}" />
      </div>
    HTML
  end
  
end