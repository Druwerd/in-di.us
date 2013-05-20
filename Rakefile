require "rspec/core/rake_task"
require 'rake/clean'

# setup globs for :clean task; see 'rake/clean' docs
CLEAN.include 'tmp/*'
CLEAN.include '*.log'

namespace :test do
  RSpec::Core::RakeTask.new(:all)
end

namespace :facebook do
	desc "Get Hot Bands Data from Facebook"
	task :get_bands_data do
		require File.join( File.dirname(__FILE__), 'lib', 'facebook_band.rb' )
		facebook_data = Facebook::BandSearch.new().get_bands_list(true)
		File.open('public/data/fb_bands_data.json', 'w') do |f|
			f << facebook_data.to_json
		end
	end
end

desc "Run tests"
task :default => "test:all"
