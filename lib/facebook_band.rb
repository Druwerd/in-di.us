require 'json'
require 'rest_client'

module Facebook
	class AppToken
		attr_reader :value

		def initialize
			@value = ""
		end
	end

	class GraphApiRequest
		attr_accessor :url

		def initialize(url)
			@url = url
		end

		def exec
			JSON.parse ::RestClient.get(url)
		end
	end

	class BandSearch
		CACHE_TIMEOUT = 60 * 60 # one hour
		@@bands_list = []
		@@bands_list_lastupdated = nil
		@@bands_list_loading = false

		def initialize
			@max_size = 5000
		end

		def get_bands_list()
			@@bands_list = load_data_from_file
			#get_bands_list_from_fb if @@bands_list.empty?
			@@bands_list
		end

		private
		def find_bands()
			bands_list = []
			search_url="https://graph.facebook.com/search?fields=name&q=musician/band&type=page&limit=#{@max_size}"
			search_results = GraphApiRequest.new(search_url).exec
			bands_list += search_results['data']
			bands_list
		end

		def get_bands_list_from_fb
			return @@bands_list if @@bands_list_lastupdated && (Time.now - @@bands_list_lastupdated) < CACHE_TIMEOUT
			return @@bands_list if @@bands_list_loading
			
			Thread.new do
				puts "execuing tread!"
				@@bands_list_loading = true

				get_get_bands_list_from_fb_now

				@@bands_list_loading = false
				puts "done"
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
			@@bands_list_lastupdated = Time.now
			@@bands_list
		end

		def load_data_from_file
			data_file = File.join( File.dirname(__FILE__), '..', 'public', 'data', 'fb_bands_data.json' )
			data = File.open(data_file).read
			JSON.parse data
		rescue => e
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