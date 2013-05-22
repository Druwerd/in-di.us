$stdout.sync = true

require './server'

use Rack::Static, :urls => ["/css", "/images"], :root => "public"

run App
