require 'sinatra/json'
require 'json'
require 'logger'
require 'tiny_tds'

require_relative 'db_client'
require_relative 'query'
require_relative 'query_string'

module GlobalNamespace
  def self.global_settings
    @gs ||= {
      metadata: Dir["public/*.json"].map { |file| JSON.parse File.read(file) }.flatten
    }
  end

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
      
      json GlobalNamespace.global_settings[:metadata]
    end
    
    # data web service
    post '/data' do
      payload     = JSON.parse request.body.read
      
      @user       = payload['user']
      @project_id = payload['project_id']
      @redcap_url = payload['redcap_url']
      @id         = payload['id']
      @fields     = payload['fields']
      
      
      LOGGER.info 'parameters:'
      LOGGER.info params.inspect
      
      results = Query.new(@id, @fields).execute
      
      json results
    end
  end
end
