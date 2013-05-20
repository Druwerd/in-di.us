class App
  include Helpers

  get "/" do
    @title = "indi - Independent Mobile Apps"
    @description = "in-di.us provides independent mobile apps. We specialize in free customized apps for bands."
    @js = "apps.js"
    haml :index
  end
  
  get "/about" do
    @title = "About indi"
    @description = "We are the best hackers alive."
    haml :about
  end
  
  get "/contact" do
    @title = "Contact Us"
    @description = "Contact information"
    haml :contact
  end

  get "/hot-bands" do
    @title = "indi"
    @description = "List of the most talked about bands on Facebook"

    @bands = Facebook::BandSearch.new().get_bands_list
    haml :hot_bands
  end
end