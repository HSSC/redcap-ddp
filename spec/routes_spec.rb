require 'spec_helper'

RSpec.describe 'routes' do

  it 'has a route for the metadata web service' do
    post '/metadata'
  end

  it 'has a route for the data web service' do
    post '/data'
  end
end
