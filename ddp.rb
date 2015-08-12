require 'json'
require 'logger'

class App < Sinatra::Application

  configure do
    LOGGER = Logger.new("log/access.log")
    enable :logging
    use Rack::CommonLogger, LOGGER
  end

  # metadata web service
  post '/metadata' do
    @user       = params['user']
    @project_id = params['project_id']
    @redcap_url = params['redcap_url']

    LOGGER.info "parameters:"
    LOGGER.info params.inspect
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

    LOGGER.info "parameters:"
    LOGGER.info req.inspect
  end
end
