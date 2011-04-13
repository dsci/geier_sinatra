String.class_eval do
  
  def to_textile
    RedCloth.new(self).to_html
  end
  
end