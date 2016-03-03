class DbClient
  
  def client
    TinyTds::Client.new db_client_params
  end

  private

  def db_client_params
    {
      dataserver:  ENV.fetch('DB_DATASERVER'),
      username:    ENV.fetch('DB_USERNAME'),
      password:    ENV.fetch('DB_PASSWORD'),
      database:    ENV.fetch('DB_DATABASE'),
      tds_version: ENV.fetch('DB_TDS_VERSION')
    }
  end
end
