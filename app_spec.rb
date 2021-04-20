require './app'


describe App do
  context "get status" do
    let(:app) { App.new }
    let(:env) { { "REQUEST_METHOD" => "GET", 'PATH_INFO' => "/" } }
    let(:response) { app.call(env) }

    it "returns the status 404" do
      expect(response[0]).to eq 404
    end 
  end  
end
