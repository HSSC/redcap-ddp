require 'time'

module GlobalNamespace
  
  class QueryString
    PATIENTS_TABLE      = 'EDW2.Patients'
    ORDER_RESULTS_TABLE = 'EDW2.Order_Results'    
    TIMESTAMP_COLUMN    = "OrderDTM"
    
    def initialize(id, fields)
      @id          = id
      @fields      = fields
      @temporal_fields, @non_temporal_fields = @fields.partition { |field| field['timestamp_max'] && field['timestamp_min'] }
    end
    
    def to_s
      [
	select_clause,
	from_clause,
	join_clause,
	where_clause
      ].compact.join(' ')
    end
    
    private

    def select_clause
      "SELECT #{columns}"
    end

    def from_clause
      "FROM #{PATIENTS_TABLE}"
    end

    def where_clause
      clause = "WHERE #{where_default}"

      if time_ranges.any?
        gross_from = time_ranges.map { |tr| tr[:from] }.min.strftime('%Y-%m-%d %H:%M:%S')
        gross_to   = time_ranges.map { |tr| tr[:to] }.max.strftime('%Y-%m-%d %H:%M:%S')

	clause += %Q{ AND (DATEFORMAT(#{prefix(TIMESTAMP_COLUMN)}, 'YYY-MM-DD HH:MM:SS') BETWEEN "#{gross_from}" AND "#{gross_to}")}
      end

      clause
    end

    def join_clause
      if @temporal_fields.any?
	"JOIN #{join_table} ON #{join_on}"
      end
    end

    def join_table
      field = @temporal_fields.first['field']
      
      if field_row = GlobalNamespace.global_settings[:metadata].find { |row| row.has_value?(field) }
	@join_table ||= field_row['category']
      end
    end

    def join_on
      "#{PATIENTS_TABLE}.PatientExternalID = #{@join_table}.PatientExternalID"
    end

    def columns
      @fields.uniq.map { |field| prefix(field) }.join(',')
    end

    def time_ranges
      @temporal_fields.map do |field|
        { from: Time.strptime(field['timestamp_min'], '%Y-%m-%d %H:%M:%S'), to: Time.strptime(field['timestamp_max'], '%Y-%m-%d %H:%M:%S') }
      end
    end

    def where_default
      "#{PATIENTS_TABLE}.SourceSystem=\"EPIC\"", "#{PATIENTS_TABLE}.PatientExternalID=\"#{@id}\""
    end
    
    def prefix(column)
      # casecmp returns 0 if strings are equal, ignoring case
      "EDW2." + (GlobalNamespace.global_settings[:metadata].find { |f| column.casecmp(f['field']).zero? })['category'] + "." + column
    end
  end
end
