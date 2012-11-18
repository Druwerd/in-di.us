class App
  post "/newsletter_singup" do
    @email = params[:email]
    haml :newsletter_singup
  end
end