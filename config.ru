require 'sinatra'
set :env, :production
disable :run

require './ftb_app.rb'

run Sinatra::Application
