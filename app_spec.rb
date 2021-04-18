require './app'


describe App do
  context "get status" do
      let(:app)      { App.new }
      let(:env)      { {"REQUEST_METHOD" => "GET"} }
      let(:response) { app.call(env) }
    it "returns the status 200" do
      expect(response[0]).to eq 200
    end  
  end  
end