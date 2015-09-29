require 'dotenv'
require 'rubygems'
require 'bundler'
require 'rack-timeout'

Bundler.require
Dotenv.load

use Rack::Timeout
Rack::Timeout.timeout = 30

require './app'

run GlobalNamespace::App
