# @author Daniel Schmidt
set :locales, File.join(File.dirname(__FILE__), 'i18n/de.yml')
# configure database access for several environments
database_urls = {
    :development => 'sqlite://sinatra-dev.db',
    :production     => 'mysql://root@127.0.0.1:/ecms2',
    :test       => 'sqlite://sinatra-test.db'
}

configure :development do
  set :database_extras, {:pool => 5, :timeout => 3000}
end

configure :production do
  set :database_extras, {:pool => 5, :timeout => 5000, :encoding => "utf8"}
end

set :database, database_urls[settings.environment]

