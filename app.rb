require "http"
require "pry"
require "trie"
require 'rack/app'

class App < Rack::App
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
    requested_path = env[::Rack::PATH_INFO]
    if requested_path == "/"
      body = [@words.to_json]
    elsif requested_path == "/pronounce/"
      body = ["Give the word"]
    elsif requested_path.include? "/pronounce/"
      word = requested_path.match(/([^\/]+)$/).captures.first
      if @trie.has_key?(word)
        body = ["Proper pronunciation of #{ word }: #{ @trie.get(word) }"]
      else
        body = ["None of the words match"]
      end
    elsif requested_path == "/suggest/"
      body = ["Give the prefix"]
    elsif requested_path.include? "/suggest/"
      prefix = requested_path.match(/([^\/]+)$/).captures.first
      body = ["10 words starting with #{ prefix } (less if the given prefix doesn't match 10 words): #{ @trie.children(prefix).sample(10) }"]
    else
      body = ["Wrong path"]
    end
    status  = 200
    headers = { "Content-Type" => "text/html" } 
    [status, headers, body]
  end
end