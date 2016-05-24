module Sybase
  class Connection
    require 'dotenv'
    Dotenv.load

    class << self; attr_accessor :table_name end
    class << self; attr_accessor :source_system end
    class << self; attr_accessor :id end

    def self.connection
      host = ENV.fetch('SYBASE_HOST'){nil}
      user = ENV.fetch('SYBASE_USER'){nil}
      pass = ENV.fetch('SYBASE_PASS'){nil}
      port = ENV.fetch('SYBASE_PORT'){nil}
      tds = ENV.fetch('SYBASE_TDS'){42}
      timeout = ENV.fetch('SYBASE_TIMEOUT'){60}

      TinyTds::Client.new(username: user, password: pass, host: host, port: port, tds_version: tds.to_i, timeout: timeout.to_i) 
    end

    def self.first
      connection.execute("SELECT top 1 * FROM #{self.table_name} as t WHERE t.SourceSystem = '#{self.source_system}'").first
    end

    def self.find id=nil, args={}
      begin
        # limit number of results returned
        limit = args[:limit] ? "TOP #{args[:limit]}" : nil

        # select only certain fields
        select = args[:select] || '*'

        query = "SELECT #{limit} #{select} FROM #{self.table_name} WHERE"
        
        # append ID to where clause
        query += " #{self.id} = '#{id}' AND" if id

        # additional conditions and SourceSystem added to where clause
        query += " #{args[:conditions]} AND" if args[:conditions]
        query += " SourceSystem = '#{self.source_system}'"

        self.execute(query)
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end

    def self.execute query
      begin
        puts "#"*50
        puts query
        puts "#"*50

        connection.execute(query).to_a
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end
