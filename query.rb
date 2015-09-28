module GlobalNamespace

  class Query < DbClient

    def initialize(id, fields)
      @id     = id
      @fields = fields.uniq { |field| field['field'] }
      @temporal_fields, @non_temporal_fields = @fields.uniq.partition { |field| field['timestamp_max'] && field['timestamp_min'] }
    end
    
    def execute
      query_string = QueryString.new(@id, @temporal_fields, @non_temporal_fields).to_s
      rows         = client.execute(query_string)
      row          = rows.each.first    
      
      row ? (non_temporal_field_values(row) + temporal_field_values(rows)) : []
    end

    private

    def temporal_field_values(rows)
      temporal_results = [] 

      rows.each do |row|
        timestamp = row[GlobalNamespace.global_settings[:timestamp_column]]

        row.delete(GlobalNamespace.global_settings[:timestamp_column])
        row.delete_if { |key, value| non_temporal_columns.include?(key) }

        row.each { |key, value| temporal_results.push({ field: key, value: value, timestamp: timestamp }) }
      end

      temporal_results
    end

    def non_temporal_field_values(row)
      results = []
      row.select { |key, value| non_temporal_columns.include?(key) }.each do |key, value|
        results.push({ field: key, value: value})
      end
      results
    end

    def non_temporal_columns
      @non_temporal_fields.map { |field| field['field'] }
    end
  end
end
