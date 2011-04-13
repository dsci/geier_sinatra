class News < ActiveRecord::Base
  
  validates :title, :presence => true
  validates :text, :presence => true
  
  default_scope :order => "created_at DESC"
  
  scope :tops, :limit => 5
  
  def url
    "/#{self.class.name}/#{self.id}"
  end
  
end