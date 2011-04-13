helpers do

  def partial(template)
    erb template, :layout => false
  end
  
  def link_to(text,url)
    "<a href=/#{url.to_s}>#{text}</a>"
  end
  
  def current_page
    @current_page ||= request.path_info
  end
  
  def active_class(url)
    current_page.eql?("/#{url}") ? "active" : "not_active"
  end
  
  def weather
    WeatherHelper.weather_info
  end
  
  def disqus_excludables
    ["/halle", "/mannschaft", "/"]
  end
  
  def page_title(prefix)
    @page_title = PAGE_TITLE.gsub("{prefix}", prefix)
  end
  
  def textilize(s)
    s.to_textile
  end
  
  # slices a text!
  def s(text)
    text.slice(0..200).concat("...")
  end
end