# MongoDb configuration file.
#
# @author Daniel Schmidt, dsci@code79.net

Mongoid.load!(File.expand_path(File.join(File.dirname(__FILE__), 'mongoid.yml')))

#MongoMapper.connection = Mongo::Connection.new('localhost')
#MongoMapper.database = "#tavex-data-shelf-#{ENV['RACK_ENV']}"