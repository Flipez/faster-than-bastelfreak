require 'rubygems'
require 'sinatra'
require 'benchmark'
require 'net/http'
require 'haml'
require 'socket'
require 'openssl'

require_relative 'models/measurement'
require_relative 'models/database'


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

get '/' do
  results = settings.db.get_all
  haml :index, :locals => {results: results, o_uri: default_host, tests: number_of_tests}
end

get '/test' do
  url = params['q']
  uri = validate_url url

  unless uri
    show_error 'Invalid URL' if not validate_url url
  else
   
    m = Measurement.new settings.db
    
    begin
      m.start uri

      settings.db.count_test
      settings.db.store m
    
      haml :result, :locals => {m: m, o_uri: m.o_uri, tests: number_of_tests}
    
    rescue Exception => e
      print e.backtrace.join("\n")
      show_error e.message
    end
  end
end
