class MHDApp
  get '/resource.html' do
    erb :'resource'
  end
  
  get '/resource' do
    content_type :json

    response = { :hello => "world" }

    response.to_json
  end
end
