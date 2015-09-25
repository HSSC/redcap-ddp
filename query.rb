module GlobalNamespace

  class Query < DbClient

    TIMESTAMP_COLUMN    = "OrderDTM"

    def initialize(id, fields)
      @id = id
      @fields = fields
    end
    
    def execute
      results      = []
      query_string = QueryString.new(@id, @fields).to_s
      rows         = client.execute(query_string)

      rows.each do |row| 
        row.each { |key, value| results.push({ field: key, value:  value }) }
      end
      
      results
    end
  end
end
