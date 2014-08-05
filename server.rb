require 'rubygems'
require "sinatra"
require "pry-byebug"

set :bind, '0.0.0.0' #for vagrant, fooooool.

get '/' do 
	erb :index
end