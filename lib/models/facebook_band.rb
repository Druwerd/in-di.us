require 'json'
require 'rest_client'
require 'time'
require 'uri'

module Facebook
	class AppToken
		attr_reader :value

		def initialize
			@value = ENV["FB_ACCESS_TOKEN"]
		end
	end

	class GraphApiRequest
		attr_accessor :url

		def initialize(url)
			@url = url
		end

		def exec
			JSON.parse ::RestClient.get(URI.escape(url))
		end
	end

	class BandSearch
		CACHE_TIMEOUT = 60 * 60 # one hour
		@@bands_list = []
		@@bands_list_timestamp = nil

		def initialize
			@max_size = 5000
			@access_token = AppToken.new
		end

		def get_bands_list()
			return @@bands_list if !@@bands_list.empty? && fresh?
			load_data_from_redis
			get_bands_list_from_fb if @@bands_list.empty? || !fresh?
			@@bands_list
		end

		private
		def loading_data?
			$REDIS.get('fb_bands_data_loading').to_s == 'true'
		end

		def last_fb_sync
			Time.parse $REDIS.get('fb_bands_data_timestamp').to_s
		rescue => e
			puts "KEEP CALM CARRY ON"
			puts e
			nil
		end

		def fresh?
			@@bands_list_timestamp && (Time.now - @@bands_list_timestamp) < CACHE_TIMEOUT
		end

		def find_bands()
			bands_list = []
			search_url="https://graph.facebook.com/search?fields=name&q=musician/band&type=page&limit=#{@max_size}&access_token=#{@access_token.value}"
			search_results = GraphApiRequest.new(search_url).exec
			bands_list += search_results['data']
			bands_list
		end

		def get_bands_list_from_fb
			return @@bands_list if fresh?
			return @@bands_list if loading_data?
			
			Thread.new do
				begin
					puts "execuing tread!"
					$REDIS.set('fb_bands_data_loading', 'true')

					get_get_bands_list_from_fb_now

					$REDIS.set('fb_bands_data_timestamp', Time.now.to_s)
					$REDIS.set('fb_bands_data', @@bands_list.to_json)
				rescue => e
					puts "FUCK ME"
					puts e
				ensure
					$REDIS.set('fb_bands_data_loading', 'false')
					puts "done"
				end
			end
			@@bands_list
		end

		def get_get_bands_list_from_fb_now
			bands = find_bands()
			bands.each do |band|
				puts band
				band['info'] = Band.new(band['id']).get_info()
			end
			@@bands_list = bands.sort_by!{|b| b['info']['talking_about_count']}.reverse
			@@bands_list
		end

		def load_data_from_redis
			puts "LOADING FROM REDIS"
			data = $REDIS.get('fb_bands_data')
			@@bands_list_timestamp = last_fb_sync
			@@bands_list = JSON.parse data
		rescue => e
			puts "KEEP CALM CARRY ON"
			puts e
			[]
		end
	end

	class Band

		def initialize(id)
			@id = id
		end

		def get_info()
			GraphApiRequest.new("https://graph.facebook.com/#{@id}").exec
		end
	end
end