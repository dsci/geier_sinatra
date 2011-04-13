module MailOperator
  
  extend self
  
  # returns mail login
  def mail_user_settings
    YAML.load_file(config_path)[env.to_s]["user"]
  end
  
  def mail_pwd_settings
    YAML.load_file(config_path)[env.to_s]["pwd"]
  end
  
  def import_news
    gmail = Gmail.new(mail_user_settings, mail_pwd_settings)
    gmail.inbox.emails.each do |email|
      if email.subject.match(/News/)
        title = email.subject.split("-").last.strip
        #puts email.from
        
        # split title 
        
        # read body
        body = email.body.decoded.split("-start-news-").last
        #split("-start-news-")
        body = body.split("-end-news-").first.gsub(/<\/?[^>]*>/, "")
        # create record
        news = News.create(:title => title, :text => body, :author => email.from)
        # delete mail
        email.delete!
      end
    end
    gmail.logout
  end
  
  def delete_news
    gmail = Gmail.new(mail_user_settings,mail_pwd_settings)
    gmail.inbox.emails.each do |email|
      if email.subject.match(/Delete/)
        splitted = email.subject.split("-")
        id = splitted.last.strip
        # try to remove news from database
        begin
          News.find(id).destroy
        rescue
        end
        email.delete!
      end
    end
  end
  
  private
  
  def config_path
    begin
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "mail.yml"))
    rescue => e
      puts "maybe no file found"
    end
  end
  
  def env
    ::Sinatra::Application.environment
  end
    
end