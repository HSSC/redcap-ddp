module GlobalNamespace

  class Query < DbClient

    TIMESTAMP_COLUMN    = "ResultsDTM"

    def initialize(id, fields)
      @id = id
      @fields = fields
    end
    
    def execute
      results      = []
      query_string = QueryString.new(@id, @fields).to_s
      puts "DEBUG: #{query_string}"
      rows         = client.execute(query_string)

      rows.each do |row| 
        timestamp = row[TIMESTAMP_COLUMN]
        row.delete(TIMESTAMP_COLUMN)
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
