class News < CCut::Base
  
  #include Mongoid::Document
  
  field :title, :type => String
  field :text, :type => String
  
  validates :title, :presence => true
  validates :text, :presence => true
  
  default_scope :order => "created_at DESC"
  
  scope :tops, :limit => 5
  
  def url
    "/#{self.class.name}/#{self.id}"
  end
  
  
  
end