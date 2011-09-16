module WeatherHelper

  extend self

  def t(s)
    case s.downcase
      when "clear" then "Klar"
      when "mostly cloudy" then "Meistens bew&ouml;lkt"
      when "rainy" then "Regnerisch"
      when "sunny" then "Sonnig"
      when "cloudy" then "Bew&ouml;lkt"
    end
  end

  def weather_info
    info = Weather.run(:location => "04205")
    data = info.parse
    #"#{info.first.celsius_high}"
    #template = <<-HTML
    #  <div id="weather_inner">
    #    <div id="location">Leipzig, <span style="font-size:0.7em;">Gr&ouml;nau</span></div>
    #    <div id="condition_img"><img src="http://google.com/#{data.icon}" /></div>
    #    <!--<div id="condition">#{data.temp_c}°C - #{t(data.condition)}</div-->
    #    <!--<div id="temperature">T: #{data.celsius_low.round}°C / H: #{data.celsius_high.round}°C</div>-->
    #  </div>
    #HTML
    template = ""
    return template
  end
  
end