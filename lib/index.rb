class App
  get "/" do
    @title = "in-di.us - Independent Mobile Apps"
    @description = "in-di.us provides independent mobile apps. We specialize in free customized apps for bands."
    @js = "apps.js"
    haml :apps
  end
  
  get "/apps" do
    @title = "Independent Mobile Apps"
    @description = "List of mobile apps created by in-di.us"
    @js = "apps.js"
    haml :apps
  end
  
  get "/about" do
    @title = "About in-di.us"
    @description = "We are the best hackers alive."
    haml :about
  end
  
  get "/contact" do
    @title = "Contact Us"
    @description = "Contact information"
    haml :contact
  end
end