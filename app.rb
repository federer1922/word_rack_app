require "http"
require "pry"
require "trie"

class App
  def initialize  
    if File.exist?("words_and pronunciations.txt") == false
      @response = HTTP.get("https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict?fbclid=IwAR3ke7nHSguLnRmynPmnJIlEQQqAGhXxZWLghswCpcX6mabsnow3WbUWqp0")
      File.open("words_and pronunciations.txt", "w") do |data|     
        data.write(@response.body.to_s)   
      end
    end
    @words = {}
    @trie = Trie.new
    File.readlines("words_and pronunciations.txt").each do |line|
      line = line.strip
      word, pronunciation = line.split(" ", 2)
      @trie.add(word, pronunciation)
      @words[word] = pronunciation
    end
  end
  
  def call(env)
    status  = 200
    headers = { "Content-Type" => "text/html" } 
    if env['PATH_INFO'] == "/"
      body = [@words.to_json]
    elsif env['PATH_INFO'] == "/pronounce/"
      body = ["Give the word"]
    elsif env['PATH_INFO'].include? "/pronounce/"
      word = env['PATH_INFO'].match(/([^\/]+)$/).captures.first
      if @trie.has_key?(word)
        body = ["Proper pronunciation of #{ word }: #{ @trie.get(word) }"]
      else
        body = ["None of the words match"]
      end
    else
      body = ["Wrong path"]
    end
    [status, headers, body]
  end
end