require 'time'

module GlobalNamespace
  
  class QueryString
    PATIENTS_TABLE      = 'EDW2.Patients'
    ORDER_RESULTS_TABLE = 'EDW2.Order_Results'    
    TIMESTAMP_COLUMN    = 'ResultsDTM'
    
    def initialize(id, fields)
      @id          = id
      @fields      = fields.uniq { |field| field['field'] }
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
      clause = "SELECT #{columns}"
      if @temporal_fields.any?
        clause += ",#{prefix(TIMESTAMP_COLUMN)}"
      end
      clause
    end

    def from_clause
      "FROM #{PATIENTS_TABLE}"
    end

    def where_clause
      clause = "WHERE #{where_default}"

      if time_ranges.any?
        gross_from = time_ranges.map { |tr| tr[:from] }.min.strftime('%Y-%m-%d %H:%M:%S')
        gross_to   = time_ranges.map { |tr| tr[:to] }.max.strftime('%Y-%m-%d %H:%M:%S')

	clause += %Q{ AND (DATEFORMAT(#{prefix(TIMESTAMP_COLUMN)}, 'YYYY-MM-DD HH:MM:SS') BETWEEN '#{gross_from}' AND '#{gross_to}')}
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
 
      @join_table ||= table_name(field) if field     
    end

    def join_on
      "#{PATIENTS_TABLE}.PatientExternalID = #{@join_table}.PatientExternalID"
    end

    def columns
      @fields.uniq.map { |field| prefix(field['field']) }.join(',')
    end

    def time_ranges
      @temporal_fields.map do |field|
        { from: Time.strptime(field['timestamp_min'], '%Y-%m-%d %H:%M:%S'), to: Time.strptime(field['timestamp_max'], '%Y-%m-%d %H:%M:%S') }
      end
    end

    def where_default
      "#{PATIENTS_TABLE}.SourceSystem='EPIC' AND #{PATIENTS_TABLE}.PatientExternalID='#{@id}'"
    end
    
    def prefix(column)
      [
        table_name(column),
        column
      ].join('.')
    end

    def table_name(column)
      [
        'EDW2',
        GlobalNamespace.global_settings[:metadata].find { |row| row.has_value?(column) }['category']
      ].join('.')
    end
  end
end
