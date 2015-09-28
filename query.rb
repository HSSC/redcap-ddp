module GlobalNamespace

  class Query < DbClient

    def initialize(id, fields)
      @id = id
      @fields = fields
    end
    
    def execute
      results      = []
      query_string = QueryString.new(@id, @fields).to_s
      rows         = client.execute(query_string)

      rows.each do |row| 
        timestamp = row[GlobalNamespace.global_settings[:timestamp_column]]
        
        row.delete(GlobalNamespace.global_settings[:timestamp_column])
        row.each do |key, value|
          if timestamp
            results.push({ field: key, value: value, timestamp: timestamp })
          else
            results.push({ field: key, value: value })
          end
        end
      end
      
      results
    end
  end
end
