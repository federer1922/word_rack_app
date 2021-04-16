
require "http"
require "pry"

class App
  def call(env)
    response = HTTP.get("https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict?fbclid=IwAR3ke7nHSguLnRmynPmnJIlEQQqAGhXxZWLghswCpcX6mabsnow3WbUWqp0")
    status  = 200
    headers = { "Content-Type" => "text/html" }
    result = {}
    response.body.to_s.split("\n").each do |line|
      word, pronunciation = line.split(" ", 2)
      result[word] = pronunciation
    end
    body = [result.keys.first.to_s]
    [status, headers, body]
  end
end