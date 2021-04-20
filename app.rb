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
  
  def self.call(env)
    new.call(env)
  end
  
  def call(env)
    requested_path = env[::Rack::PATH_INFO]
    if requested_path == "/"
      status  = 404
      headers = { "Content-Type" => "text/html" } 
      body = ["404 Not Found! Use paths: /pronounce/:word or /suggest/:prefix"]
    elsif requested_path == "/pronounce/"
      status  = 404
      headers = { "Content-Type" => "text/html" } 
      body = ["404 Not Found! Give the word"]
    elsif requested_path.include? "/pronounce/"
      word = requested_path.match(/([^\/]+)$/).captures.first
      if @trie.has_key?(word)
        status  = 200
        headers = { "Content-Type" => "text/html" } 
        body = ["Proper pronunciation of #{ word }: #{ @trie.get(word) }"]
      else
        status  = 200
        headers = { "Content-Type" => "text/html" } 
        body = ["None of the words match"]
      end
    elsif requested_path == "/suggest/"
      status  = 404
      headers = { "Content-Type" => "text/html" } 
      body = ["404 Not Found! Give the prefix"]
    elsif requested_path.include? "/suggest/"
      prefix = requested_path.match(/([^\/]+)$/).captures.first
      status  = 200
      headers = { "Content-Type" => "text/html" } 
      body = ["10 words starting with #{ prefix } (less if the given prefix doesn't match 10 words): #{ @trie.children(prefix).sample(10) }"]
    else
      status  = 404
      headers = { "Content-Type" => "text/html" } 
      body = ["404 Not Found! Use paths: /pronounce/:word or /suggest/:prefix"]
    end
    
    [status, headers, body]
  end
end