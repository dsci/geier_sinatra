module WeatherHelper

  extend self

  def t(s)
    case s.downcase
      when "clear" then "Klar"
      when "mostly cloudy" then "Meistens bewölkt"
      when "rainy" then "Regnerisch"
      when "sunny" then "Sonnig"
      when "cloudy" then "Bewölkt"
    end
  end

  def weather_info
    info = Weather.run(:location => "04205")
    data = info.parse
    #"#{info.first.celsius_high}"
    <<-HTML
      <div id="weather_inner">
        <div id="location">Leipzig, <span style="font-size:0.7em;">Grünau</span></div>
        <div id="condition_img"><img src="http://google.com/#{data.icon}" /></div>
        <div id="condition">#{data.temp_c}°C - #{t(data.condition)}</div>
        <div id="temperature">T: #{data.celsius_low.round}°C / H: #{data.celsius_high.round}°C</div>
      </div>
    HTML
  end
  
end