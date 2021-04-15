# This file is used by Rack-based servers to start the application.

# require_relative 'config/environment'

# run Rails.application

require "rack"
require "http"
require "pry"

class Application
    def call(env)

      response = HTTP.get("https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict?fbclid=IwAR3ke7nHSguLnRmynPmnJIlEQQqAGhXxZWLghswCpcX6mabsnow3WbUWqp0")
      status  = 200
      headers = { "Content-Type" => "text/html" }
      body    = [response.body.to_s]

      [status, headers, body]
    end
  end
  
  run Application.new
