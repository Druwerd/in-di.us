class App
  get "/" do
    @description = "in-di.us provides independent mobile apps. We specialize in free customized apps for indie bands that earn you money."
    haml :index
  end
end