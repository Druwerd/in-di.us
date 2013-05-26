require 'json'
require 'haml'
require 'redis'

# load helpers and models
Dir[ File.join( File.dirname(__FILE__), 'helpers', '*.rb') ].each { |f| require f }
Dir[ File.join( File.dirname(__FILE__), 'models', '*.rb') ].each { |f| require f }

class App < Sinatra::Application

  include ::Helpers

  def ensure_connections
    # connect to DB here
    $REDIS = Redis.new(:host => settings.redis_host, :port => settings.redis_port, :password => settings.redis_password)
  end

  before do
    ensure_connections
    response.headers['Cache-Control'] = 'public, max-age=604800'
    response.headers['Content-Language'] = 'en'
    content_type :html, 'charset' => 'utf-8'
    
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

# load controllers
Dir[ File.join( File.dirname(__FILE__), 'controllers', '*.rb') ].each { |f| require f }