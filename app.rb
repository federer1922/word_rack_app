
require "http"
require "pry"

class App
  def initialize
    @response = HTTP.get("https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict?fbclid=IwAR3ke7nHSguLnRmynPmnJIlEQQqAGhXxZWLghswCpcX6mabsnow3WbUWqp0")
    @words = {}
    @response.body.to_s.split("\n").each do |line|
      word, pronunciation = line.split(" ", 2)
      @words[word] = pronunciation
    end
  end
  
  def call(env)
    status  = 200
    headers = { "Content-Type" => "text/html" } 
    if env['PATH_INFO'] == "/"
      body = [@words.to_json]
    elsif env['PATH_INFO'].include? "/pronounce/"
      word = env['PATH_INFO'].match(/([^\/]+)$/).captures.first
      if @words[word].nil?
        body = ["None of the words match"]
      else
        body = ["Proper pronunciation of #{ word }: #{ @words[word] }"]
      end
    else
      body = ["Wrong path"]
    end
    [status, headers, body]
  end
end