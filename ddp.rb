require 'json'

class App < Sinatra::Application

  # metadata web service
  post '/metadata' do
    @user       = params['user']
    @project_id = params['project_id']
    @redcap_url = params['redcap_url']
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
  end
end
