require 'bundler/setup'
require 'sinatra'

set :fb_access_token => ENV["FB_ACCESS_TOKEN"]

configure :production do
  require 'newrelic_rpm'
  redis_uri = URI.parse ENV["REDISCLOUD_URL"]
  set :redis_host => redis_uri.host, :redis_port => redis_uri.port, :redis_password => redis_uri.password
end

configure :development do
  redis_uri = URI.parse "http://localhost:6379"
  set :redis_host => redis_uri.host, :redis_port => redis_uri.port, :redis_password => redis_uri.password
end
require './lib/app.rb'
