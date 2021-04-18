
require "http"
require "pry"

class App
  def initialize
    @response = HTTP.get("https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict?fbclid=IwAR3ke7nHSguLnRmynPmnJIlEQQqAGhXxZWLghswCpcX6mabsnow3WbUWqp0")
    @result = {}
    @response.body.to_s.split("\n").each do |line|
      word, pronunciation = line.split(" ", 2)
      @result[word] = pronunciation
    end
  end
  
  def call(env)
    status  = 200
    headers = { "Content-Type" => "text/html" } 
    body = [@result.to_json]
    [status, headers, body]
  end
end