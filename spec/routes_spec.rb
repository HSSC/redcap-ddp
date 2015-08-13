require 'spec_helper'

RSpec.describe 'routes' do
  include Rack::Test::Methods

  it 'has a route for the metadata web service' do
    post '/metadata'
  end

  it 'has a route for the data web service' do
    post '/data'
  end

  def app
    App.new
  end
end
