require 'dotenv'
require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load

require './app'

run GlobalNamespace::App
