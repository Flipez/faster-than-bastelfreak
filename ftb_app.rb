require 'rubygems'
require 'sinatra'
require 'benchmark'
require 'net/http'
require 'haml'

require_relative 'models/measurement'
require_relative 'models/database'


set :db, Database.new

def default_host
  "#{request.scheme}://#{request.host}"
end

def show_error e
  haml :error, locals: {errormsg: e, o_uri: default_host}
end

get '/' do
  results = settings.db.get_all
  haml :index, :locals => {results: results, o_uri: default_host}
end

get '/test' do
  url = params['q']

  if url=~URI::regexp
    url = URI(url)
   
    m = Measurement.new
    
    begin
      m.start url
    
      settings.db.store m
    
      haml :result, :locals => {m: m, o_uri: m.o_uri}
    
    rescue Exception => e
      show_error e.message
    end
  
  else
    show_error 'No or invalid url given'
  end
end
