class App
  get "/" do
    @title = "in-di.us - Independent Mobile Apps"
    @description = "in-di.us provides independent mobile apps. We specialize in free customized apps for indie bands."
    haml :index
  end
  
  get "/apps" do
    @title = "in-di.us - Independent Mobile Apps"
    @description = "List of mobile apps created by in-di.us"
    haml :apps
  end
  
  get "/about" do
    @title = "in-di.us - About Us"
    @description = "We are the best hackers alive."
    haml :about
  end
  
  get "/contact" do
    @title = "in-di.us - Contact Us"
    @description = "Contact information"
    haml :contact
  end
end