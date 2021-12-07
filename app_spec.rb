# frozen_string_literal: true

require './app'
require 'digest'

describe do
  include Rack::App::Test
  rack_app App

  it 'gets / path' do
    expect(get('/').status).to eq 404
    expect(get('/').body).to eq '404 Not Found! Use paths: /pronounce/:word or /suggest/:prefix'
  end

  it 'gets /pronounce/ path' do
    expect(get('/pronounce/').status).to eq 404
    expect(get('/pronounce/').body).to eq '404 Not Found! Give the word'
  end

  it 'gets /pronounce/:word path' do
    expect(get('/pronounce/cat').status).to eq 200
    expect(get('/pronounce/cat').body).to eq "Proper pronunciation of cat: #{InitializeTrieService.call.get('cat')}"
    expect(get('/pronounce/wrong_word').status).to eq 200
    expect(get('/pronounce/wrong_word').body).to eq "None of the words match"
  end

  it 'gets /suggest/ path' do
    expect(get('/suggest/').status).to eq 404
    expect(get('/suggest/').body).to eq '404 Not Found! Give the prefix'
  end

  it 'gets /suggest/:prefix path' do
    expect(get('/suggest/ab').status).to eq 200
    expect(get('/suggest/ab').body).to eq "10 words starting with ab (less if the given prefix doesn't match 10 words): #{InitializeTrieService.call.children('ab').first(10).join(', ')}"
  end

  it 'gets wrong path' do
    expect(get('/wrong_path').status).to eq 404
    expect(get('/wrong_path').body).to eq '404 Not Found'
  end
end
