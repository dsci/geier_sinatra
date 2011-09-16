require 'spec_helper'

describe "CCut" do
  
  include Rack::Test::Methods
  
  def create_news
    attributes = {
      :title => Faker::Lorem.words,
      :text => Faker::Lorem.paragraphs
    }
    @news = News.create(attributes)
  end

  def app 
    @app ||= CCut::Application
  end
  
  before do
    user_attributes = {
      :email => "foo@@foo.de", :password=>"foo1223",
      :password_confirmation => "foo1223"
    }
    @user = MongoidUser.create(user_attributes)
    
  end
  
  context "/news" do
    
    before do
      
    end
    
    context "#post" do
      
      context "create news" do
        
        before do
          @attributes = {:title => "fooo", :text => "sddsdsds"}
        end
        
        it "succeeds" do
          authorize @user.email, @user.password
          
          post "/news", :news => @attributes
          last_response.should be_ok
          result = Yajl::Parser.parse(last_response.body)
          result["success"].should be true
          result["news"].should_not be nil
          result["news"].first["news"]["title"].should == @attributes[:title]
        end
        
        it "fails" do
          @attributes.delete(:title)
          post "/news", :news => @attributes
          last_response.should be_ok
          result = Yajl::Parser.parse(last_response.body)
          result["success"].should be false
          result["errors"].should_not be nil
          
        end
        
      end
    end
    
    context "#put" do
      
      before do
        create_news
      end

      context "update a news" do
        
        it "succeeds" do
          attributes = {:title => "Updated news!"}
          put "/news/#{@news.id}", :news => attributes
          last_response.should be_ok
          result = Yajl::Parser.parse(last_response.body)
          result["success"].should be true
          result["news"].first["news"]["title"].should == attributes[:title]  
        end
        
        it "fails" do
          attributes = {:title => "", :text => "Only text"}
          put "/news/#{@news.id}", :news => attributes
          result = Yajl::Parser.parse(last_response.body)
          result["success"].should be false
        end
        
      end
      
    end
    
    context "#delete" do
      
      before do
        
      end

      context "delete a news" do
        
        it "succeeds" do
          create_news
          delete "/news/#{@news.id}"
          result = Yajl::Parser.parse(last_response.body)
          result["success"].should be true
        end
        
        it "fails" do
          delete "/news/1234"
          result = Yajl::Parser.parse(last_response.body)
          result["success"].should be false
        end
      end
    end
  end
  
  
end