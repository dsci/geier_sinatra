module CCut
  
  class Base
    
    include Mongoid::Document
    
    def as_json
      {self.class.name.downcase => self.attributes}
    end
    
  end
end