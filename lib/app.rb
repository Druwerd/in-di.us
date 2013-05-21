require 'json'
require 'haml'
require 'redis'

class App < Sinatra::Application

  def ensure_connections
    # connect to DB here
    case ENV['RACK_ENV']
    when 'production'
      uri = URI.parse(ENV["REDISCLOUD_URL"])
      $REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      $REDIS = Redis.new(:host => 'localhost', :port => 6379)
    end
  end

  before do
    ensure_connections
    response.headers['Cache-Control'] = 'public, max-age=604800'
    response.headers['Content-Language'] = 'en'
    
    @errors = {} # empty error response. see #after for how this gets handled.
  end

  def errors?
    @errors.keys.length > 0
  end
  
  after do
    halt_with_errors! if errors?
  end
  
  not_found do
    haml :not_found
  end

end

# load in all of the other .rb files in this directory
Dir[ File.join( File.dirname(__FILE__), '*.rb') ].each { |f| require f }
