class App
  get "/" do
    @description = "in-di.us provides independent mobile apps. We specialize in free customized apps for indie bands."
    haml :index
  end
  
  get "/apps" do
    @description = "List of mobile apps created by in-di.us"
    haml :apps
  end
  
  get "/about" do
    @description = "About in-di.us"
    haml :about
  end
  
  get "/contact" do
    @description = "Contact information"
    haml :contact
  end
end