require 'dotenv'

Dotenv.load

require 'json'
require 'logger'
require 'sqlanywhere'
require 'dbi'

set :database_file, 'config/database.yml'

class App < Sinatra::Application

  configure do
    LOGGER = Logger.new 'log/access.log'

    enable :logging
    use Rack::CommonLogger, LOGGER
  end

  # test
  get '/' do

    LOGGER.info 'test:'
    LOGGER.info
  end

  # metadata web service
  post '/metadata' do
    @user       = params['user']
    @project_id = params['project_id']
    @redcap_url = params['redcap_url']

    LOGGER.info 'parameters:'
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

    LOGGER.info 'parameters:'
    LOGGER.info req.inspect
  end

  private

  def establish_db_connection
    @api = SQLAnywhere::SQLAnywhereInterface.new()

    SQLAnywhere::API.sqlany_initialize_interface(@api)
    @api.sqlany_init()

    conn = @api.sqlany_new_connection()
    @api.sqlany_connect(conn, "uid=dba;pwd=sql")
  end
end
