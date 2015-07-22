require 'rubygems'
require 'sinatra'
require 'benchmark'
require 'net/http'
require 'haml'
require 'socket'
require 'openssl'
require 'json'

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
  halt  haml :error, locals: {errormsg: e, o_uri: default_host, tests: number_of_tests}
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

get '/' do
  results = settings.db.get_all
  haml :index, :locals => {results: results, o_uri: default_host, tests: number_of_tests}
end

get '/test' do
  url = params['q']
  uri = validate_url url
  if uri
    result = start_test uri
    haml :result, :locals => {m: result, o_uri: result.o_uri, tests: number_of_tests}
  else
    show_error 'Invalid URL'
  end
end

get '/api' do
  url = params['q']
  uri = validate_url url
  if uri
    result = start_test uri
    show_json result
  else
    {error: 'Invalid URL'}.to_json
  end
end
