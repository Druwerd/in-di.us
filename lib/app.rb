require 'json'
require 'haml'

class App < Sinatra::Application

  def ensure_connections
    # connect to DB here
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
