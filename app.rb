require 'json'
require 'logger'
require 'tiny_tds'

require_relative 'db_client'
require_relative 'query'

class App < Sinatra::Application

  configure do
    LOGGER = Logger.new 'log/access.log'

    enable :logging
    use Rack::CommonLogger, LOGGER
  end

  # metadata web service
  post '/metadata' do
    @user       = params['user']
    @project_id = params['project_id']
    @redcap_url = params['redcap_url']

    LOGGER.info 'parameters:'
    LOGGER.info params.inspect

    content_type :json

    File.read 'public/metadata.json'
  end

  # data web service
  post '/data' do
    request.body.rewind
    req         = JSON.parse request.body.read

    @user       = req['user']
    @project_id = req['project_id']
    @redcap_url = req['redcap_url']
    @id         = req['id']
    @fields     = req['fields']

    LOGGER.info 'parameters:'
    LOGGER.info req.inspect

    content_type :json

    results = Query.new(@id, @fields).execute
    
    results.to_json
  end
end
