module GlobalNamespace
  class Query < DbClient
        
    def initialize(id, fields)
      @id = id
      @fields = fields
      @temporal_fields, @non_temporal_fields = fields.partition { |field| field['timestamp_max'] && field['timestamp_min'] }
    end
    
    def execute
      results      = []
      query_string = QueryString.new(@id).
        sql_select(@non_temporal_fields).
        to_s
      rows         = client.execute(query_string)

      rows.each do |row| 
        row.each { |key, value| results.push({ field: key, value:  value }) }
      end
      
      results
    end
  end
end
