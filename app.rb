# frozen_string_literal: true

require 'http'
require 'pry'
require 'trie'
require 'rack/app'

class InitializeTrieService
  def self.call
    if File.exist?('words_and pronunciations.txt') == false
      @response = HTTP.get('https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict?fbclid=IwAR3ke7nHSguLnRmynPmnJIlEQQqAGhXxZWLghswCpcX6mabsnow3WbUWqp0')
      File.open('words_and pronunciations.txt', 'w') do |data|
        data.write(@response.body.to_s)
      end
    end
    @trie = Trie.new
    @words = {}
    File.readlines('words_and pronunciations.txt').each do |line|
      line = line.strip
      word, pronunciation = line.split(' ', 2)
      @trie.add(word, pronunciation)
      @words[word] = pronunciation
    end
    @trie
  end
end

class App < Rack::App
  def initialize
    @trie = InitializeTrieService.call
  end

  get '/' do
    response.status = 404
    '404 Not Found! Use paths: /pronounce/:word or /suggest/:prefix'
  end

  get '/pronounce/' do
    response.status = 404
    '404 Not Found! Give the word'
  end

  get '/pronounce/:word' do
    params['word']
    if @trie.has_key?(params['word'])
      "Proper pronunciation of #{params['word']}: #{@trie.get(params['word'])}"
    else
      'None of the words match'
    end
  end

  get '/suggest/' do
    response.status = 404
    '404 Not Found! Give the prefix'
  end

  get '/suggest/:prefix' do
    params['prefix']
    "10 words starting with #{params['prefix']} (less if the given prefix doesn't match 10 words): #{@trie.children(params['prefix']).first(10).join(', ')}"
  end
end
