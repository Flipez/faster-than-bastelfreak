require 'rubygems'
require 'sinatra'
require 'benchmark'
require 'net/http'
require 'haml'

require_relative 'models/measurement'
require_relative 'models/database'


set :db, Database.new

def show_home url
  results = settings.db.get_all
  haml :index, :locals => {:url => url, :results => results}
end

def show_result m
  haml :result, :locals => {:m => m, :url => m.o_uri}
end

get '/' do
  url = params['q']

  if url=~URI::regexp
    url = URI(url)
   
    m = Measurement.new
    m.start url

    settings.db.store m
    
    show_result m   
  
  else
    show_home 'https://flipez.de/blog'
  end
end
