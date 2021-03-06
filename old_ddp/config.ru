require 'dotenv'

Dotenv.load

require 'rubygems'
require 'bundler'
require 'rack-timeout'
require './app'

Bundler.require(:default, ENV.fetch('RACK_ENV').to_sym)

use Rack::Timeout
Rack::Timeout.timeout = 30

run GlobalNamespace::App
