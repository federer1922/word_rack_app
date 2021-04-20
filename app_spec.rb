# frozen_string_literal: true

require './app'

describe do
  include Rack::App::Test
  rack_app App

  it 'returns the status and body for different paths' do
    expect(get('/').status).to eq 404
    expect(get('/').body).to eq '404 Not Found! Use paths: /pronounce/:word or /suggest/:prefix'

    expect(get('/pronounce/').status).to eq 404
    expect(get('/pronounce/').body).to eq '404 Not Found! Give the word'

    expect(get('/pronounce/cat').status).to eq 200
    expect(get('/pronounce/cat').body).to eq 'Proper pronunciation of cat: K AE1 T'

    expect(get('/suggest/').status).to eq 404
    expect(get('/suggest/').body).to eq '404 Not Found! Give the prefix'

    expect(get('/suggest/ab').status).to eq 200
    expect(get('/suggest/ab').body.include?("10 words starting with ab (less if the given prefix doesn't match 10 words): ")).to be true

    expect(get('/bad_path').status).to eq 404
    expect(get('/bad_path').body).to eq '404 Not Found! Use paths: /pronounce/:word or /suggest/:prefix'
  end
end
