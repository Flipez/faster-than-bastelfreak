require 'rubygems'
require 'sinatra'
require 'sinatra/contrib'
require 'benchmark'
require 'net/http'
require 'tilt/haml'
require 'socket'
require 'openssl'
require 'json'
require 'sinatra/logger'

require_relative 'lib/database'
require_relative 'models/measurement'
require_relative 'ftb_app/api'
require_relative 'ftb_app/helper'
require_relative 'ftb_app/error'

set :db, Database.new

set :root, '/home/robert/git/faster-than-bastelfreak/'

before /.*/ do
  if request.path_info.match(/.json$/)
    content_type :json, 'charset' => 'utf-8'
    request.accept.unshift('application/json')
    request.path_info = request.path_info.gsub(/.json$/,'')
  else
    content_type :html, 'charset' => 'utf-8'
 end
end

get '/' do
  results = settings.db.get_all
  haml :index, :locals => {results: results, o_uri: default_host, tests: number_of_tests}
end

get '/test', provides: [:html, :json] do
  url = params['q']
  uri = validate_url url
  logger.debug(uri)
  if uri
    result = start_test uri
    show_result result
  else
    show_error 'Invalid URL'
  end
end

