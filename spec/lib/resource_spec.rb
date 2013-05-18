require File.join( File.dirname(__FILE__), '..', 'spec_helper')

describe "Resource" do
  
  it "should have a root" do
    get '/'
    last_response.should be_ok
  end

  it "should have about page" do
    get '/about'
    last_response.should be_ok
  end

  it "should have contact page" do
    get '/contact'
    last_response.should be_ok
  end
  
  it "should say indi" do
    get '/'
    last_response.should be_ok
    last_response.body.should include('indi')
  end

  it "should say about us" do
    get '/about'
    last_response.should be_ok
    last_response.body.downcase.should include('about us')
  end

  it "should say contact us" do
    get '/contact'
    last_response.should be_ok
    last_response.body.downcase.should include('contact us')
  end
  
end
