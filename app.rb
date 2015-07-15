require 'rubygems'
require 'sinatra'
require 'benchmark'
require 'net/http'
require 'haml'

bastel = URI('https://blog.bastelfreak.de')

def req uri
  response = Net::HTTP.get_response(uri)
end

def measure uri
  Benchmark.realtime do
    req uri
  end
end

def show_home
  haml :index, :locals => {:url => ''}
end

def show_result url, result, bastel, opponent
  haml :result, :locals => {:url => url.to_s,
                            :result => result,
                            :bastel => bastel,
                            :opponent => opponent}
end

get '/' do
  url = params['q']

  if url=~URI::regexp
    url = URI(url)
    
    time1 = measure bastel
    time2 = measure url
    result = ( ( time1 / time2 ) *100 ).round / 100.0
  
    p "Requested site: #{url}"
    p "Bastelfreak loaded in #{time1}"
    p "#{url} loaded in #{time2}"
    
    time1 = ( time1 * 100 ).round / 100.0
    time2 = ( time2 * 100 ).round / 100.0
    
    show_result url, result, time1, time2   
  
  else
    show_home
  end
end
