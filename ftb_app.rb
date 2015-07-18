require 'rubygems'
require 'sinatra'
require 'benchmark'
require 'net/http'
require 'haml'
require 'socket'
require 'openssl'

require_relative 'models/measurement'
require_relative 'models/database'
require_relative 'models/api'


set :db, Database.new

def default_host
  "#{request.scheme}://#{request.host}"
end

def number_of_tests
  settings.db.number_of_tests
end

def show_error e
  haml :error, locals: {errormsg: e, o_uri: default_host, tests: number_of_tests}
end

def validate_url url
  uri = URI.parse(url)
  if uri.instance_of? URI::HTTPS
    uri 
  else
    false
  end
end

def start_test uri
  unless uri
    show_error 'Invalid URL' if not validate_url url
  else
   
    m = Measurement.new settings.db
    
    begin
      m.start uri

      settings.db.count_test
      settings.db.store m
  
      return m

    rescue Exception => e
      print e.backtrace.join("\n")
      show_error e.message
    end
  end
end

get '/' do
  results = settings.db.get_all
  haml :index, :locals => {results: results, o_uri: default_host, tests: number_of_tests}
end

get '/test' do
  url = params['q']
  uri = validate_url url

  result = start_test uri
  haml :result, :locals => {m: result, o_uri: result.o_uri, tests: number_of_tests}
end

get '/api' do
  url = params['q']
  uri = validate_url url

  result = start_test uri
  p result
  show_json result
end
