require "spec_helper"

describe MailOperator do

  context "configuration" do
    
    it "should read the user login information from config file" do
      MailOperator::mail_user_settings.should == "web@skaterhockey-leipzig.de"
    end
    
    it "should read the user pwd information from config file" do
      MailOperator::mail_pwd_settings.should == "pggeier08"
    end
  end

  context "fetching mail" do
    
    it "should create a new record if email to create was found" do
      # soll die anzahl der news in der db um eins erhöhen.
      expect{
        MailOperator::import_news
      }.to change{News.count}.by(1)
    end
    
    it "should destroy an record if email to destroy was found" do
      expect{ 
        MailOperator::delete_news
      }.to change{News.count}.by(-1)
      
    end
    
  end
  
  

end